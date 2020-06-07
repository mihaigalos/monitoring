#! /bin/bash

# set up ramdisk
sudo mkdir -p /mnt/prometheus_logs
sudo chown $USER:$USER /mnt/prometheus_logs
sudo mount -t tmpfs -o size=100M tmpfs /mnt/prometheus_logs

# copy logs to ramdisk
sudo systemctl stop prometheus
cp -r data /mnt/prometheus_logs
rm -r data
ln -s /mnt/prometheus_logs/data .

sudo systemctl restart prometheus

# sync to disk every night at 04:00
(crontab -l ; echo "0 4 * * * mkdir -p $HOME/prometheus_logs && cp -r /mnt/prometheus_logs/data  $HOME/prometheus_logs") | crontab -

# make it permanent after reboot
grep /mnt/prometheus_logs /etc/mtab | sudo tee -a /etc/fstab

echo "TODO: Symlink from data to ramdisk on each reboot"

