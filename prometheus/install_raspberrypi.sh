#! /bin/bash
# Code adapted from https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04

ARCH=${ARCH:-arm64}
VERSION=${VERSION:-2.17.1}
TARGET=prometheus-${VERSION}.linux-${ARCH}

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
