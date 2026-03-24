#!/bin/bash

# Define the command and the full cron job entry
CRON_CMD="@reboot /var/www/myblazorapp/FleetAPI"
CRON_JOB="0 */4 * * * $CRON_CMD" # Runs every 4 hours

# Check if the command is already in the crontab
if ! crontab -l | grep -q "$CRON_CMD"; then
  # If not found, append the new job and install the modified crontab
  (crontab -l; echo "$CRON_JOB") | crontab -
  echo "Cron job added: $CRON_JOB"
else
  echo "Cron job already exists. No action taken."
fi
