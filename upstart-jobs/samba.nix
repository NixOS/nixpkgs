{samba, glibc, pwdutils}:

let
  user="smbguest";
  group="smbguest";

in

{
  name = "samba";

  job = "

description \"Samba Service\"

start on network-interfaces/started
stop on network-interfaces/stop

start script

 if ! ${glibc}/bin/getent group ${group} > /dev/null; then
      ${pwdutils}/sbin/groupadd ${group}
 fi

 if ! ${glibc}/bin/getent passwd ${user} > /dev/null; then
      ${pwdutils}/sbin/useradd -g ${group} -d /var/empty -s /noshell -c 'Samba service user' ${user}
 fi

 ${samba}/sbin/nmbd -D &
 ${samba}/sbin/smbd -D &
 ${samba}/sbin/winbindd -B &

end script

respawn ${samba}/sbin/nmbd -D &; ${samba}/sbin/smbd -D &; ${samba}/sbin/winbindd -B &

  ";

}
