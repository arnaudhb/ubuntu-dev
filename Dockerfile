FROM arnaudhb/ubuntu-dev:java

ENV APACHE_MAVEN_VERSION 3.5.0
ENV MAVEN_HOME /opt/maven
ENV M2_HOME /opt/maven

ENV GRADLE_VERSION 3.5
ENV GRADLE_HOME /opt/gradle

ENV PATH $PATH:$MAVEN_HOME/bin:$GRADLE_HOME/bin


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
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# Install Grunt-CLI
RUN npm install -g grunt-cli

# Install Gulp
RUN npm install -g gulp-cli


# Entrypoint
COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
