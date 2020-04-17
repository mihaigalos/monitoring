#! /bin/bash
# Code adapted from https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04

ARCH=${ARCH:-arm64}
VERSION=${VERSION:-2.17.1}
TARGET=prometheus-${VERSION}.linux-${ARCH}



install_binary(){
    echo "Installing the prometheus service."

    sudo useradd --no-create-home --shell /bin/false prometheus

    sudo mkdir /etc/prometheus
    sudo chown prometheus:prometheus /etc/prometheus

    sudo mkdir /var/lib/prometheus
    sudo chown prometheus:prometheus /var/lib/prometheus

    pushd /tmp
    curl -LO https://github.com/prometheus/prometheus/releases/download/v${VERSION}/${TARGET}.tar.gz
    tar -xvf ${TARGET}.tar.gz

    sudo cp ${TARGET}/prometheus /usr/local/bin/
    sudo chown prometheus:prometheus /usr/local/bin/prometheus

    sudo cp -r ${TARGET}/consoles /etc/prometheus
    sudo chown -R prometheus:prometheus /etc/prometheus/consoles
    sudo cp -r ${TARGET}/console_libraries /etc/prometheus
    sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

    rm -rf ${TARGET}.tar.gz ${TARGET}

    popd
}

install service() {
    echo "Installing the prometheus service."
    sudo bash -c 'cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target

EOF'

    sudo systemctl daemon-reload
    sudo systemctl start prometheus
    sudo systemctl status prometheus

    sudo systemctl enable prometheus
}

bind_to_socket(){
    echo "Please enter socket for the node_exporter in form ip:port. I.e.: 192.168.0.100:9100."
    read -p "ip:port = " SOCKET
    echo "Configuring Prometheus for socket $SOCKET".

    sed -i "s/\(.*\)localhost:.*'\(.*\)/\1$SOCKET'\2/" /etc/prometheus/prometheus.yml
}

install_binary
install_service
bind_to_socket
