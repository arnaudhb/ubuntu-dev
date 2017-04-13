FROM arnaudhb/ubuntu-dev:build-automation

ENV IDE_ATOM_VERSION v1.15.0

# Get Atom IDE
ADD https://github.com/atom/atom/releases/download/$IDE_ATOM_VERSION/atom-amd64.deb /src

# Install Atom IDE
RUN apt-get update && apt-get install -y \
 gconf2 \
 libnotify4 \
 python \
 gvfs-bin \
&& dpkg -i '/src/atom-amd64.deb' \
&& rm -rf /src/*.deb \
&& rm -rf /var/lib/apt/lists/*


# Get Eclipse installer
ADD http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/oomph/products/eclipse-inst-linux64.tar.gz /opt
RUN cd /opt && tar xzf eclipse-inst-linux64.tar.gz

# Install node packages
RUN npm install -g swagger

# Install Postman standalone application
ADD https://dl.pstmn.io/download/latest/linux64 /opt
RUN cd /opt && tar xzf linux64 && rm linux64
RUN echo "alias postman='/opt/Postman/Postman > /dev/null 2>&1'" >> /root/.bash_aliases

# Add --no-sandbox flag in chrome alias (since Chrome 55+)
RUN sed -i "s/--user-data-dir/--user-data-dir --no-sandbox/g" /root/.bash_aliases

# Remove duplicated google repo
RUN rm /etc/apt/sources.list.d/google.list

# Update some packages to latest version
RUN apt-get update && apt-get install -y \
google-chrome-stable \
nodejs \
&& rm -rf /var/lib/apt/lists/*

# Cleanup
RUN rm -f /opt/*.tar.gz

# Exposed volume(s)
VOLUME [ '/root/.atom' ]

# Exposed port(s)
EXPOSE 5858
EXPOSE 3000

# Entrypoint
COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
