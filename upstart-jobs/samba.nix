{pkgs, samba, glibc}:

let
  
  user = "smbguest";
  group = "smbguest";
  
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

  ${samba}/sbin/nmbd -D &
  ${samba}/sbin/smbd -D &
  ${samba}/sbin/winbindd -B &

end script

respawn ${samba}/sbin/nmbd -D &; ${samba}/sbin/smbd -D &; ${samba}/sbin/winbindd -B &

  ";

}
