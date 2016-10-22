FROM arnaudhb/ubuntu-dev:java

ENV APACHE_MAVEN_VERSION 3.3.9
ENV MAVEN_HOME /opt/maven
ENV M2_HOME /opt/maven
ENV PATH $PATH:$MAVEN_HOME/bin

# Install Maven 3
RUN cd /opt \
&& wget -q http://apache.mindstudios.com/maven/maven-3/$APACHE_MAVEN_VERSION/binaries/apache-maven-$APACHE_MAVEN_VERSION-bin.tar.gz \
&& tar xzf *maven*.tar.gz \
&& rm -rf *maven*.tar.gz \
&& ln -s /opt/*maven*/ maven

# Entrypoint
COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
