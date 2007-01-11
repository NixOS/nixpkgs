{glibc, pwdutils}:

{
  name = "nscd";
  
  job = "
description \"Name Service Cache Daemon\"

start on startup
stop on shutdown

start script

    if ! ${glibc}/bin/getent passwd nscd > /dev/null; then
        ${pwdutils}/sbin/useradd -g nogroup -d /var/empty -s /noshell \\
            -c 'Name service cache daemon user' nscd
    fi

    mkdir -m 0755 -p /var/run/nscd
    mkdir -m 0755 -p /var/db/nscd
    
end script

# !!! -d turns on debug info which probably makes nscd slower
# 2>/dev/null is to make it shut up
respawn ${glibc}/sbin/nscd -f ${./nscd.conf} -d 2> /dev/null
  ";
  
}
