FROM arnaudhb/ubuntu-dev:java

ENV APACHE_MAVEN_VERSION 3.3.9
ENV MAVEN_HOME /opt/maven
ENV M2_HOME /opt/maven

ENV GRADLE_VERSION 3.1
ENV GRADLE_HOME /opt/gradle

ENV NODE_HOME /opt/node
ENV NODE_VERSION 6.8.1

ENV PATH $PATH:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$NODE_HOME/bin


# Install Maven 3
RUN cd /opt \
&& wget -q http://apache.mindstudios.com/maven/maven-3/$APACHE_MAVEN_VERSION/binaries/apache-maven-$APACHE_MAVEN_VERSION-bin.tar.gz \
&& tar xzf *maven*.tar.gz \
&& rm -rf *maven*.tar.gz \
&& ln -s /opt/*maven*/ maven

# Install Gradle 3
RUN cd /opt \
&& wget -q https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
&& unzip -qq *.zip \
&& rm -rf *.zip \
&& ln -s /opt/*gradle*/ gradle 

# Install NodeJS
RUN cd /opt \
&& wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz \
&& tar xf node*.tar.xz \
&& rm -f node*.tar.xz \
&& ln -s /opt/node*/ node

# Install Grunt-CLI
RUN npm install -g grunt-cli

# Install Gulp
RUN npm install -g gulp-cli


# Entrypoint
COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
