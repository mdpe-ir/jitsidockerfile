# Use the official Docker image for Jitsi
FROM jitsi/base-java

# Set environment variables (adjust these according to your setup)
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    gnupg2 \
    apt-transport-https \ 
    nginx-full \
    sudo \
    curl \
    && apt-get clean


RUN apt-add-repository universe

RUN  apt update 

RUN curl -sL https://prosody.im/files/prosody-debian-packages.key -o /etc/apt/keyrings/prosody-debian-packages.key
RUN echo "deb [signed-by=/etc/apt/keyrings/prosody-debian-packages.key] http://packages.prosody.im/debian $(lsb_release -sc) main" |  tee /etc/apt/sources.list.d/prosody-debian-packages.list
RUN apt install -y  lua5.2

RUN curl -sL https://download.jitsi.org/jitsi-key.gpg.key |  sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
RUN echo "deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/" | tee /etc/apt/sources.list.d/jitsi-stable.list

RUN apt update 

run apt-get install -y jitsi-meet


# Expose the necessary ports
EXPOSE 80 443 10000/udp 22 3478/udp 5349/tcp

# Start the necessary services
CMD service nginx start && /usr/share/jitsi-meet/scripts/init.sh



