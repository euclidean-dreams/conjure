#!/bin/bash

sudo cp ~/conjure/services/analogorium.service /etc/systemd/system/analogorium.service
sudo cp ~/conjure/services/cosmographer.service /etc/systemd/system/cosmographer.service
sudo cp ~/conjure/services/luciferon.service /etc/systemd/system/luciferon.service
sudo cp ~/conjure/services/promenade.service /etc/systemd/system/promenade.service

sudo cp /home/josiah/euclidean-dreams/analogorium/cmake-build-sjofn/analogorium /usr/local/analogorium
sudo cp /home/josiah/euclidean-dreams/cosmographer/cmake-build-sjofn/cosmographer /usr/local/cosmographer
sudo cp /home/josiah/euclidean-dreams/luciferon/cmake-build-sjofn/luciferon /usr/local/luciferon
sudo cp /home/josiah/euclidean-dreams/promenade/cmake-build-sjofn/promenade /usr/local/promenade

sudo systemctl enable analogorium.service
sudo systemctl enable cosmographer.service
sudo systemctl enable luciferon.service
sudo systemctl enable promenade.service

sudo cp ~/sjofn.service /etc/systemd/system/sjofn.service
sudo systemctl enable sjofn.service
