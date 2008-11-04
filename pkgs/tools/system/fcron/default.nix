# I've only worked on this till it compiled and worked. So maybe there are some things which should be done but I've missed
# restart using 'killall -TERM fcron; fcron -b
# use convert-fcrontab to update fcrontab files

args:
args.stdenv.mkDerivation {
  name = "fcron-3.0.4";

  src = args.fetchurl {
    url = http://fcron.free.fr/archives/fcron-3.0.4.src.tar.gz;
    sha256 = "15kgphsfa0nqgjd8yxyz947x2xyljj4iyh298kw4c8bz6iznqxn8";
  };

  buildInputs =(with args; [perl]);

  configureFlags = [ "--with-sendmail=/var/setuid-wrappers/sendmail"
                    "--with-editor=/var/run/current-system/sw/bin/vi"
                    "--with-bootinstall=no"
                    # fcron would have been default user/grp
                    "--with-username=root"
                    "--with-groupname=root"
                  ];
  preConfigure = ''
    sed -i 's@/usr/bin/env perl@${args.perl}/bin/perl@g' configure
    # Don't let fcron create the group fcron, nix(os) should do this
    sed -i '2s@.*@exit 0@' script/user-group

    # --with-bootinstall=no shoud do this, didn't work. So just exit the script before doing anything
    sed -i '2s@.*@exit 0@' script/boot-install

    # also don't use chown or chgrp for documentation (or whatever) when installing
    find -type f | xargs sed -i -e 's@^\(\s\)*chown@\1:@' -e 's@^\(\s\)*chgrp@\1:@'
  '';

  meta = { 
      description="A command scheduler with extended capabilities over cron and anacron";
      homepage =  http://fcron.free.fr;
      license = "GPLv2";
  };
}
