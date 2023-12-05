FROM ubuntu:latest

# Set noninteractive mode
ENV DEBIAN_FRONTEND=noninteractive
# Install cron and other dependencies
RUN apt-get update && \
    apt-get -y install cron && \
    apt-get -y install wget gzip && \
    apt-get install -y postgresql-client &&\
    rm -rf /var/lib/apt/lists/*

# Reset noninteractive mode
ENV DEBIAN_FRONTEND=    

# Copy script and cron file
COPY ./DataPipeline_shell /home/DataPipeline_shell

# Add crontab file to the cron directory
ADD DataPipeline_shell/cronfile /etc/cron.d/DataPipeline_shell-cron

# Give execution rights to the cron job
# Create the log file to be able to run tail
RUN chmod 0644 /etc/cron.d/DataPipeline_shell-cron &&\
    /usr/bin/crontab  /etc/cron.d/DataPipeline_shell-cron &&\
    touch /var/log/cron.log

# Run cron in the foreground
CMD cron && tail -f /var/log/cron.log