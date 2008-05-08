{ writeText, openssh, glibc, xauth
, nssModulesPath
, forwardX11, allowSFTP, permitRootLogin
}:

assert permitRootLogin == "yes" ||
       permitRootLogin == "without-password" ||
       permitRootLogin == "forced-commands-only" ||
       permitRootLogin == "no";
       
let

  sshdConfig = writeText "sshd_config" ''

    Protocol 2
    
    UsePAM yes
    
    ${if forwardX11 then "
      X11Forwarding yes
      XAuthLocation ${xauth}/bin/xauth
    " else "
      X11Forwarding no
    "}

    ${if allowSFTP then "
      Subsystem sftp ${openssh}/libexec/sftp-server
    " else "
    "}
    
    PermitRootLogin ${permitRootLogin}
    
  '';

  sshdUid = (import ../system/ids.nix).uids.sshd;

in

{
  name = "sshd";

  users = [
    { name = "sshd";
      uid = (import ../system/ids.nix).uids.sshd;
      description = "SSH privilege separation user";
      home = "/var/empty";
    }
  ];
  
  job = ''
    description "SSH server"

    start on network-interfaces/started
    stop on network-interfaces/stop

    env LD_LIBRARY_PATH=${nssModulesPath}

    start script
        mkdir -m 0755 -p /etc/ssh

        if ! test -f /etc/ssh/ssh_host_dsa_key; then
            ${openssh}/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ""
        fi
    end script

    respawn ${openssh}/sbin/sshd -D -h /etc/ssh/ssh_host_dsa_key -f ${sshdConfig}
  '';
  
}
