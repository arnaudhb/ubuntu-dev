FROM arnaudhb/ubuntu-dev-base

ENV ORACLE_JAVA_PATH b14
ENV ORACLE_JAVA_VERSION 8u102

# Get  Hangout plugin
ADD https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb /src/google-talkplugin_current_amd64.deb

# Install packages for sound and display support
RUN apt-get update && apt-get install -y \
 ca-certificates \
 gnupg \
 hicolor-icon-theme \
 libgl1-mesa-glx \
 libpulse0 pulseaudio \
 libv4l-0 \
 fonts-symbola \
 dbus-x11 \
 libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module \
 --no-install-recommends \

# Install Google Chrome
&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
&& echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
&& apt-get update && apt-get install -y \
 google-chrome-stable \
 --no-install-recommends \

# Install Hangout plugin
&& dpkg -i '/src/google-talkplugin_current_amd64.deb' \
&& rm -rf /src/*.deb \
&& rm -rf /var/lib/apt/lists/*

# Add fonts
COPY add/etc/fonts/local.conf /etc/fonts/local.conf

# Add files to root homedir
COPY add/root/* /root

# Add an alias for launching Google Chrome
RUN echo "alias chrome='google-chrome --user-data-dir > /dev/null 2>&1'" >> /root/.bash_aliases

# Install Java 8
RUN  cd /opt \
&& wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
http://download.oracle.com/otn-pub/java/jdk/$ORACLE_JAVA_VERSION-$ORACLE_JAVA_PATH/jdk-$ORACLE_JAVA_VERSION-linux-x64.tar.gz \
&& tar xzf jdk-*.tar.gz \
&& rm -f jdk-*.tar.gz \
&& ln -s /opt/jdk*_*/ jdk

# Volumes
VOLUME [ "/root/.config/google-chrome" ]

# Entrypoint
COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
