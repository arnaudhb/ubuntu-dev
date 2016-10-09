FROM arnaudhb/ubuntu-dev-base

# Get hangout plugin
ADD https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb /src/google-talkplugin_current_amd64.deb

# Install Chrome
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
&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
&& echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
&& apt-get update && apt-get install -y \
 google-chrome-stable \
 --no-install-recommends \
&& dpkg -i '/src/google-talkplugin_current_amd64.deb' \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /src/*.deb

COPY add/etc/fonts/local.conf /etc/fonts/local.conf
COPY add/root/* /root

CMD [ "bash" ]