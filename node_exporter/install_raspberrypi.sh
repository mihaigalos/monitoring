#! /bin/bash
# Code adapted from https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04

ARCH=${ARCH:-arm64}
VERSION=${VERSION:-0.18.1}
TARGET=node_exporter-${VERSION}.linux-${ARCH}

install_binary(){
    echo "Installing the node_exporter binary."
    sudo useradd --no-create-home --shell /bin/false node_exporter

    pushd /tmp

    curl -LO https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/${TARGET}.tar.gz
    tar -xvf ${TARGET}.tar.gz

    sudo cp ${TARGET}/node_exporter /usr/local/bin/
    sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

    rm -rf ${TARGET}.tar.gz ${TARGET}
    popd
}

install_service() {
    echo "Installing the node_exporter service."
    sudo bash -c 'cat <<EOF >/etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target

EOF'

    sudo systemctl daemon-reload
    sudo systemctl start node_exporter
    sudo systemctl status node_exporter

    sudo systemctl enable node_exporter
}

install_binary
install_service
