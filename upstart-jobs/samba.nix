{pkgs, samba, glibc, pwdutils}:

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
  
  job = "

description \"Samba Service\"

start on network-interfaces/started
stop on network-interfaces/stop

start script

  if ! ${glibc}/bin/getent group ${group} > /dev/null; then
       ${pwdutils}/sbin/groupadd ${group}
  fi

  ${samba}/sbin/nmbd -D &
  ${samba}/sbin/smbd -D &
  ${samba}/sbin/winbindd -B &

end script

respawn ${samba}/sbin/nmbd -D &; ${samba}/sbin/smbd -D &; ${samba}/sbin/winbindd -B &

  ";

}
