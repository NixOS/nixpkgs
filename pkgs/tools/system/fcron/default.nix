# I've only worked on this till it compiled and worked. So maybe there are some things which should be done but I've missed
# restart using 'killall -TERM fcron; fcron -b
# use convert-fcrontab to update fcrontab files

{ stdenv, fetchurl, perl, busybox, vim }:

stdenv.mkDerivation rec {
  name = "fcron-3.1.2";

  src = fetchurl {
    url = "http://fcron.free.fr/archives/${name}.src.tar.gz";
    sha256 = "0p8sn4m3frh2x2llafq2gbcm46rfrn6ck4qi0d0v3ql6mfx9k4hw";
  };

  buildInputs = [ perl ];

  configureFlags =
    [ "--with-sendmail=${busybox}/sbin/sendmail"
      "--with-editor=${vim}/bin/vi"  # TODO customizable
      "--with-bootinstall=no"
      "--sysconfdir=/etc"
      # fcron would have been default user/grp
      "--with-username=root"
      "--with-groupname=root"
      "--with-rootname=root"
      "--with-rootgroup=root"
      "--disable-checks"
    ];
    
  installTargets = "install-staged"; # install does also try to change permissions of /etc/* files
  
  preConfigure =
    ''
      sed -i 's@/usr/bin/env perl@${perl}/bin/perl@g' configure script/*
      # Don't let fcron create the group fcron, nix(os) should do this
      sed -i '2s@.*@exit 0@' script/user-group

      # --with-bootinstall=no shoud do this, didn't work. So just exit the script before doing anything
      sed -i '2s@.*@exit 0@' script/boot-install

      # also don't use chown or chgrp for documentation (or whatever) when installing
      find -type f | xargs sed -i -e 's@^\(\s\)*chown@\1:@' -e 's@^\(\s\)*chgrp@\1:@'
    '';

  patchPhase =
    ''
      # don't try to create /etc/fcron.{allow,deny,conf} 
      sed -i -e 's@test -f $(DESTDIR)$(ETC)/fcron.conf @ # @' \
             -e 's@if test ! -f $(DESTDIR)$(ETC)/fcron.allow@ # @' Makefile.in
    '';

  meta = { 
    description="A command scheduler with extended capabilities over cron and anacron";
    homepage = http://fcron.free.fr;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
