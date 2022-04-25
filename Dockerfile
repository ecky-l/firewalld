FROM fedora:35
MAINTAINER "ecky-l @ github.com"
LABEL maintainer="ecky-l @ github.com"
RUN dnf -y install firewalld && dnf clean all && rm -rf /var/cache/dnf
VOLUME /run/dbus/system_bus_socket
ENTRYPOINT ["firewalld", "--nofork", "--nopid"]
