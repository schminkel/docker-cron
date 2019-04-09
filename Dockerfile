FROM ubuntu:latest

# Install cron, vim, rsyslog
RUN apt-get update
RUN apt-get -y install -qq --force-yes cron
RUN apt-get -y install -qq --force-yes rsyslog

# Add shell script and grant execution rights
ADD script.sh /script.sh
RUN chmod +x /script.sh

# Add cron job to crontab file
RUN crontab -l | { cat; echo "* * * * * /bin/sh /script.sh >/dev/null 2>&1"; } | crontab -

# Create the log file to be able to run tail
CMD touch /var/log/syslog

# Start services show syslog
CMD ["sh","-c","service rsyslog start && service cron start && tail -f /var/log/syslog"]