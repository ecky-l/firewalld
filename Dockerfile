FROM fedora:35
RUN dnf -y install firewalld && dnf clean all && rm -rf /var/cache/dnf
VOLUME /run/dbus/system_bus_socket
ENTRYPOINT ["firewalld“, "--nofork", "--nopid"]
