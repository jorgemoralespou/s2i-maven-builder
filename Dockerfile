FROM centos/s2i-base-centos7:latest
MAINTAINER Jorge Morales <jmorales@redhat.com>


ENV BUILDER_VERSION 1.0 \
    MAVEN_VERSION=3.5.2

LABEL io.k8s.description="Platform for building applications with maven on OpenShift" \
      io.k8s.display-name="Maven S2I builder 1.0" \
      io.openshift.tags="builder,maven-3" \
      io.openshift.s2i.destination="/opt/s2i/destination"

# Install Maven, Wildfly 
RUN INSTALL_PKGS="tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    (curl -v https://www.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-3.5.2/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && \
    mkdir -p /opt/s2i/destination && \
    mkdir -p /output

# Add s2i wildfly customizations
ADD ./contrib/settings-s2i.xml $HOME/.m2/

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./sti/bin/ $STI_SCRIPTS_PATH

RUN chown -R 1001:0 $HOME && \
    chmod -R ug+rw /output && \
    chmod -R g+rw /opt/s2i/destination

USER 1001

CMD $STI_SCRIPTS_PATH/usage
