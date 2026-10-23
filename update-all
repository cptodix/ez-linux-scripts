#!/bin/bash

# Define the update sequence
# 1. Refresh zypper repositories
# 2. Perform distribution upgrade (Tumbleweed style)
# 3. Update all System-wide Flatpaks safely using sudo
# 4. Remove unused Flatpak runtimes using sudo

konsole --noclose -e /bin/bash -c "
echo '--- Starting System Refresh & Update ---';
sudo zypper ref && sudo zypper dup && \
echo '--- Starting Flatpak Updates ---';
sudo flatpak update -y && \
echo '--- Cleaning up unused Flatpaks ---';
sudo flatpak uninstall --unused -y && \
echo '--- All updates completed! ---'"
