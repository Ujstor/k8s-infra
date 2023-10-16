FROM jenkins/ssh-agent

WORKDIR /home/jenkins

COPY . .

RUN apt update && \
    apt -y install python3 python3-pip docker jq git wget curl unzip && \
    curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    bash -c "echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google-chrome.list" && \
    apt -y update && \
    apt -y install google-chrome-stable && \
    wget "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/118.0.5993.70/linux64/chromedriver-linux64.zip" && \
    unzip chromedriver-linux64.zip && \
    mv chromedriver-linux64/chromedriver /usr/bin/chromedriver && \
    chown root:root /usr/bin/chromedriver && \
    chmod +x /usr/bin/chromedriver && \
    rm -f chromedriver_linux64.zip

RUN chmod +x docker_tag.sh && chmod +x pytest.sh


CMD ["bash"]
