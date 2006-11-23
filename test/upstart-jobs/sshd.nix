{openssh}:

{
  name = "sshd";
  
  job = "
description \"SSH server\"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    mkdir -m 0555 -p /var/empty

    mkdir -m 0755 -p /etc/ssh

    echo 'X11Forwarding yes' > /etc/ssh/sshd_config

    if ! test -f /etc/ssh/ssh_host_dsa_key; then
        ${openssh}/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ''
    fi

    if ! grep -q '^sshd:' /etc/passwd; then
        echo 'sshd:x:74:74:SSH privilege separation user:/var/empty:/noshell' >> /etc/passwd
    fi

end script

respawn ${openssh}/sbin/sshd -h /etc/ssh/ssh_host_dsa_key -f /etc/ssh/sshd_config
  ";
  
}
