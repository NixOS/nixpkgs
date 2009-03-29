{pkgs, samba, glibc}:

let
  
  user = "smbguest";
  group = "smbguest";
 
  #smbConfig = ./smb.conf ;

  smbConfig = pkgs.substituteAll {
    src = ./smb.conf;
    inherit samba;
  };

in

{
  name = "samba";

  users = [
    { name = user;
      description = "Samba service user";
      group = group;
    }
  ];
  
  groups = [
    { name = group;
    }
  ];
  
  job = "

description \"Samba Service\"

start on network-interfaces/started
stop on network-interfaces/stop

start script

  if ! test -d /home/smbd ; then 
    mkdir -p /home/smbd
    chown ${user} /home/smbd
    chmod a+rwx /home/smbd
  fi

  if ! test -d /var/samba ; then
    mkdir -p /var/samba/locks /var/samba/cores/nmbd  /var/samba/cores/smbd /var/samba/cores/winbindd
  fi

  ${samba}/sbin/nmbd -D  -s ${smbConfig} &
  ${samba}/sbin/smbd -D  -s ${smbConfig} &
  ${samba}/sbin/winbindd -s ${smbConfig} &

  ln -fs ${smbConfig} /var/samba/config

end script

respawn ${samba}/sbin/nmbd -D -s ${smbConfig} &; ${samba}/sbin/smbd -D -s ${smbConfig} &; ${samba}/sbin/winbindd &

  ";

}
