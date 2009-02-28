{ vsftpd, anonymousUser, localUsers
, anonymousUploadEnable, anonymousMkdirEnable, writeEnable
}:

{
  name = "vsftpd";

  groups = [
    { name = "ftp";
      gid = (import ../system/ids.nix).gids.ftp;
    }
  ];
  
  users = [
    { name = "vsftpd";
      uid = (import ../system/ids.nix).uids.vsftpd;
      description = "VSFTPD user";
      home = "/homeless-shelter";
    }
  ] ++
  (if anonymousUser then [
    { name = "ftp";
      uid = (import ../system/ids.nix).uids.ftp;
      group = "ftp";
      description = "Anonymous ftp user";
      home = "/home/ftp";
    } 
  ]
  else
  []);
  
  job = "
description \"vsftpd server\"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    cat > /etc/vsftpd.conf <<EOF
" + 
    (if anonymousUser then 
"anonymous_enable=YES"
    else
"anonymous_enable=NO") +
(if localUsers then 
"
local_enable=YES"
else
"
local_enable=NO"
) +
(if writeEnable then 
"
write_enable=YES"
else
"
write_enable=NO"
) +
(if anonymousUploadEnable then 
"
anon_upload_enable=YES"
else
"
anon_upload_enable=NO"
) +
(if anonymousMkdirEnable then 
"
anon_mkdir_write_enable=YES"
else
"
anon_mkdir_write_enable=NO"
) +
"
background=NO
listen=YES
nopriv_user=vsftpd
secure_chroot_dir=/var/ftp/empty
EOF

" + 
    (if anonymousUser then 
"
    mkdir -p /home/ftp &&
    chown -R ftp:ftp /home/ftp
"
    else "") +
"
    mkdir -p /var/ftp/empty &&
    chown vsftpd /var/ftp/empty
end script

respawn ${vsftpd}/sbin/vsftpd /etc/vsftpd.conf
  ";
  
}
