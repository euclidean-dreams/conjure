#!/bin/bash

sudo cp ~/conjure/services/analogorium.service /etc/systemd/system/analogorium.service
sudo cp ~/conjure/services/cosmographer.service /etc/systemd/system/cosmographer.service
sudo cp ~/conjure/services/luciferon.service /etc/systemd/system/luciferon.service
sudo cp ~/conjure/services/promenade.service /etc/systemd/system/promenade.service

sudo systemctl enable analogorium.service
sudo systemctl enable cosmographer.service
sudo systemctl enable luciferon.service
sudo systemctl enable promenade.service

sudo cp ~/sjofn.service /etc/systemd/system/sjofn.service
sudo systemctl enable sjofn.service
