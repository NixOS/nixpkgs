{ lib, stdenv, fetchurl, pkg-config, systemd, util-linux, coreutils, wall, hostname, man
, enableCgiScripts ? true, gd
}:

assert enableCgiScripts -> gd != null;

stdenv.mkDerivation rec {
  pname = "apcupsd";
  name = "${pname}-3.14.14";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0rwqiyzlg9p0szf3x6q1ppvrw6f6dbpn2rc5z623fk3bkdalhxyv";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ util-linux man ] ++ lib.optional enableCgiScripts gd;

  configureFlags = [
    "--bindir=${placeholder "out"}/bin"
    "--sbindir=${placeholder "out"}/bin"
    "--sysconfdir=${placeholder "out"}/etc/apcupsd"
    "--mandir=${placeholder "out"}/share/man"
    "--with-halpolicydir=${placeholder "out"}/share/halpolicy"
    "--localstatedir=/var/"
    "--with-nologin=/run"
    "--with-log-dir=/var/log/apcupsd"
    "--with-pwrfail-dir=/run/apcupsd"
    "--with-lock-dir=/run/lock"
    "--with-pid-dir=/run"
    "--enable-usb"
  ] ++ lib.optionals enableCgiScripts [
    "--enable-cgi"
    "--with-cgi-bin=${placeholder "out"}/libexec/cgi-bin"
  ];

  prePatch = ''
    sed -e "s,\$(INSTALL_PROGRAM) \$(STRIP),\$(INSTALL_PROGRAM)," \
        -i ./src/apcagent/Makefile ./autoconf/targets.mak
  '';

  # ./configure ignores --prefix, so we must specify some paths manually
  # There is no real reason for a bin/sbin split, so just use bin.
  preConfigure = ''
    export ac_cv_path_SHUTDOWN=${systemd}/sbin/shutdown
    export ac_cv_path_WALL=${wall}/bin/wall
    sed -i 's|/bin/cat|${coreutils}/bin/cat|' configure
  '';

  postInstall = ''
    for file in "$out"/etc/apcupsd/*; do
        sed -i -e 's|^WALL=.*|WALL="${wall}/bin/wall"|g' \
               -e 's|^HOSTNAME=.*|HOSTNAME=`${hostname}/bin/hostname`|g' \
               "$file"
    done
  '';

  meta = with lib; {
    description = "Daemon for controlling APC UPSes";
    homepage = "http://www.apcupsd.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
