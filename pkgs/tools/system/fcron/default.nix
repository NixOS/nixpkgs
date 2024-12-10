# restart using 'killall -TERM fcron; fcron -b
# use convert-fcrontab to update fcrontab files

{
  lib,
  stdenv,
  fetchurl,
  perl,
  busybox,
  vim,
}:

stdenv.mkDerivation rec {
  pname = "fcron";
  version = "3.3.1";

  src = fetchurl {
    url = "http://fcron.free.fr/archives/${pname}-${version}.src.tar.gz";
    sha256 = "sha256-81naoIpj3ft/4vlkuz9cUiRMJao2+SJaPMVNNvRoEQY=";
  };

  buildInputs = [ perl ];

  patches = [ ./relative-fcronsighup.patch ];

  configureFlags = [
    "--with-sendmail=${busybox}/sbin/sendmail"
    "--with-editor=${vim}/bin/vi" # TODO customizable
    "--with-bootinstall=no"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-rootname=root"
    "--with-rootgroup=root"
    "--disable-checks"
  ];

  installTargets = [ "install-staged" ]; # install does also try to change permissions of /etc/* files

  # fcron tries to install pid into system directory on install
  installFlags = [
    "ETC=."
    "PIDDIR=."
    "PIDFILE=fcron.pid"
    "REBOOT_LOCK=fcron.reboot"
    "FIFODIR=."
    "FIFOFILE=fcron.fifo"
    "FCRONTABS=."
  ];

  preConfigure = ''
    sed -i 's@/usr/bin/env perl@${perl}/bin/perl@g' configure script/*
    # Don't let fcron create the group fcron, nix(os) should do this
    sed -i '2s@.*@exit 0@' script/user-group

    # --with-bootinstall=no shoud do this, didn't work. So just exit the script before doing anything
    sed -i '2s@.*@exit 0@' script/boot-install

    # also don't use chown or chgrp for documentation (or whatever) when installing
    find -type f | xargs sed -i -e 's@^\(\s\)*chown@\1:@' -e 's@^\(\s\)*chgrp@\1:@'
  '';

  meta = with lib; {
    description = "A command scheduler with extended capabilities over cron and anacron";
    homepage = "http://fcron.free.fr";
    license = licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
