{openssh, glibc, pwdutils}:

{
  name = "sshd";
  
  job = "
description \"SSH server\"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    mkdir -m 0555 -p /var/empty

    mkdir -m 0755 -p /etc/ssh

    if ! test -f /etc/ssh/ssh_host_dsa_key; then
        ${openssh}/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ''
    fi

    if ! ${glibc}/bin/getent passwd sshd > /dev/null; then
        ${pwdutils}/sbin/useradd -g nogroup -d /var/empty -s /noshell \\
            -c 'SSH privilege separation user' sshd
    fi
end script

respawn ${openssh}/sbin/sshd -D -h /etc/ssh/ssh_host_dsa_key -f ${./sshd_config}
  ";
  
}
