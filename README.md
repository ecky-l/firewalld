# firewalld
Docker image for firewalld

## Rationale

Run firewalld in docker or podman to manage ports and services on the host system. Especially useful on container linux like Fedora CoreOS or Rancher.

## Usage

### DBUS 
The DBUS service must be running on the host and properly configured (should be the default on usual linux systems, even on container linux).
The following DBUS config snippet was taken from a normal Fedora server installation and must be added *on the host*:

```
$ sudo cat <<EOF >/etc/dbus-1/system.d/FirewallD.conf
<?xml version="1.0" encoding="UTF-8"?> <!-- -*- XML -*- -->

<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>

  <!-- Only root can own the service and send signals -->
  <policy user="root">
    <allow own="org.fedoraproject.FirewallD1"/>
    <allow own="org.fedoraproject.FirewallD1.config"/>
    <allow send_destination="org.fedoraproject.FirewallD1"/>
    <allow send_destination="org.fedoraproject.FirewallD1.config"/>
  </policy>

  <!-- Allow anyone to invoke methods on the interfaces,
       authorization is performed by PolicyKit -->
  <policy context="default">
    <allow send_destination="org.fedoraproject.FirewallD1"/>
    <allow send_destination="org.fedoraproject.FirewallD1"
           send_interface="org.freedesktop.DBus.Introspectable"/>
    <allow send_destination="org.fedoraproject.FirewallD1"
           send_interface="org.freedesktop.DBus.Properties"/>
    <allow send_destination="org.fedoraproject.FirewallD1.config"/>
  </policy>

</busconfig>
EOF
```

The DBUS socket must be mounted as volume into the container: `-v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket`.
Add `:z` for selinux relabeling (on Fedora CoreOS)

### Capabilities
The container must be run with `--privileged` mode. I have not yet found out which capabilities are really needed for the DBUS socket to work.

### Example docker run command

```
docker run -d \
        --privileged \
        -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
        eleh/firewalld
```