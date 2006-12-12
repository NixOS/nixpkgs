{openssh}:

{
  name = "sshd";
  
  job = "
description \"SSH server\"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    source ${../helpers/accounts.sh}

    mkdir -m 0555 -p /var/empty

    mkdir -m 0755 -p /etc/ssh

    if ! test -f /etc/ssh/ssh_host_dsa_key; then
        ${openssh}/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ''
    fi

    if ! userExists sshd; then
        createUser sshd x 74 74 'SSH privilege separation user' /var/empty /noshell
    fi

end script

respawn ${openssh}/sbin/sshd -D -h /etc/ssh/ssh_host_dsa_key -f ${./sshd_config}
  ";
  
}
