#! /bin/bash


ARCH=${ARCH:-arm64}
VERSION=${VERSION:-2.17.1}

sudo useradd --no-create-home --shell /bin/false prometheus

sudo mkdir /etc/prometheus
sudo chown prometheus:prometheus /etc/prometheus

sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

pushd /tmp
curl -LO https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-${ARCH}.tar.gz
tar -xvf prometheus-${VERSION}.linux-${ARCH}.tar.gz

sudo cp prometheus-${VERSION}.linux-${ARCH}/prometheus /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus

sudo cp -r prometheus-${VERSION}.linux-${ARCH}/consoles /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles

rm -rf prometheus-${VERSION}.linux-${ARCH}.tar.gz prometheus-${VERSION}.linux-${ARCH}

popd
