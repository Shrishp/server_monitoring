# server_monitoring

This project provides a lightweight **Bash-based server monitoring solution** that tracks key system metrics such as **CPU usage, memory usage, and disk space**. It logs these metrics and sends **real-time alerts to a Slack channel** when defined thresholds are exceeded.

## Key Features
- **Monitors:**
  - CPU usage
  - Memory usage
  - Disk usage
- **Slack Alerts:** Instant notifications via a configured Slack webhook.
- **Logging:** Saves monitoring data to `/var/log/server_monitor.log` for historical analysis.
- **Automated Execution:** Easily scheduled with `cron` to run at regular intervals.
- **Lightweight:** Requires no external dependencies other than standard Linux utilities and `curl`.

## How It Works
1. Collects system metrics using built-in Linux commands (`top`, `free`, `df`).
2. Compares each metric against predefined thresholds.
3. Logs the status and triggers a Slack notification if thresholds are exceeded.
4. Can be run manually or set up with `cron` for continuous monitoring.

## Step-by-Step Setup
### Step 1: Save the Script
```bash
sudo vim /usr/local/bin/monitor.sh
sudo chmod +x /usr/local/bin/monitor.sh
```

### Step 2: Test the Slack Alert
```bash
sudo nano /usr/local/bin/monitor.sh
```
Uncomment the test line at the bottom:
```bash
curl -X POST -H 'Content-type: application/json' --data '{"text":"Test message from Server Monitoring Script."}' $SLACK_WEBHOOK_URL
```
Run the script:
```bash
sudo /usr/local/bin/monitor.sh
```
Check Slack for the test message.

### Step 3: Re-disable the Test Line
Comment the test `curl` line again.

### Step 4: Check Server Logs
```bash
tail -f /var/log/server_monitor.log
```

### Step 5: Automate with Cron
```bash
sudo crontab -e
*/5 * * * * /usr/local/bin/monitor.sh
```

### Step 6: Verify Alerts
```bash
yes > /dev/null &
```
Wait and check Slack.
<img width="997" height="250" alt="Screenshot 2025-07-20 at 1 53 10 PM" src="https://github.com/user-attachments/assets/15ad2510-9116-445e-a415-4bb8ef00eebc" />

## How to Create a Slack Webhook URL
1. Go to [https://api.slack.com/apps](https://api.slack.com/apps).
2. Create a new app → From Scratch.
3. Enable Incoming Webhooks.
4. Add a webhook to your desired channel.
5. Copy the Webhook URL:
``` 
https://hooks.slack.com/services/Txxxx/Bxxxx/xxxxxxxx
```

## License
This project is free to use and modify for personal or commercial purposes.

