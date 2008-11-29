{ at, config }:

let uid = (import ../system/ids.nix).uids.atd;
    gid = (import ../system/ids.nix).gids.atd;
in
{
  name = "atd";
  
  users = [
    { name = "atd";
      inherit uid;
      description = "atd user";
      home = "/var/empty";
    }
  ];

  groups = [
    { name = "atd";
      inherit gid;
    }
  ];

  job = ''
description "at daemon (atd)"

start on startup
stop on shutdown

start script
   # Snippets taken and adapted from the original `install' rule of
   # the makefile.

   # We assume these values are those actually used in Nixpkgs for
   # `at'.
   spooldir=/var/spool/atspool
   jobdir=/var/spool/atjobs
   etcdir=/etc/at

   for dir in "$spooldir" "$jobdir" "$etcdir"
   do
     if [ ! -d "$dir" ]
     then
         mkdir "$dir" && chown atd:atd "$dir"
     fi
   done
   chmod 1770 "$spooldir" "$jobdir"
   ${if config.allowEveryone then ''chmod a+rwxt "$spooldir" "$jobdir" '' else ""}
   if [ ! -f "$etcdir"/at.deny ]
   then
       touch "$etcdir"/at.deny && \
       chown root:atd "$etcdir"/at.deny && \
       chmod 640 "$etcdir"/at.deny
   fi
   if [ ! -f "$jobdir"/.SEQ ]
   then
       touch "$jobdir"/.SEQ && \
       chown atd:atd "$jobdir"/.SEQ && \
       chmod 600 "$jobdir"/.SEQ
   fi
end script

respawn ${at}/sbin/atd
'';
  
}
