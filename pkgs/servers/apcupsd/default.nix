{ stdenv, fetchurl, pkgconfig, systemd, utillinux, coreutils, nettools, man
, enableCgiScripts ? true, gd
}:

stdenv.mkDerivation rec {
  pname = "apcupsd";
  name = "${pname}-3.14.10";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0ci0xyg1hzj8lnmm3vxfsvgpb3wdgh1ii3gb8jgdxyqnk7nba1q7";
  };

  buildInputs = [ pkgconfig utillinux man ] ++ stdenv.lib.optional enableCgiScripts gd;

  # ./configure ignores --prefix, so we must specify some paths manually
  # There is no real reason for a bin/sbin split, so just use bin.
  preConfigure = ''
    export ac_cv_path_SHUTDOWN=${systemd}/sbin/shutdown
    export ac_cv_path_WALL=${utillinux}/bin/wall
    sed -i 's|/bin/cat|${coreutils}/bin/cat|' configure
    export configureFlags="\
        --bindir=$out/bin \
        --sbindir=$out/bin \
        --sysconfdir=$out/etc/apcupsd \
        --mandir=$out/share/man \
        --with-halpolicydir=$out/share/halpolicy \
        --localstatedir=/var/ \
        --with-nologin=/run \
        --with-log-dir=/var/log/apcupsd \
        --with-pwrfail-dir=/run/apcupsd \
        --with-lock-dir=/run/lock \
        --with-pid-dir=/run \
        --enable-usb \
        ${stdenv.lib.optionalString enableCgiScripts "--enable-cgi --with-cgi-bin=$out/libexec/cgi-bin"}
        "
  '';

  postInstall = ''
    for file in "$out"/etc/apcupsd/*; do
        sed -i -e 's|^WALL=.*|WALL="${utillinux}/bin/wall"|g' \
               -e 's|^HOSTNAME=.*|HOSTNAME=`${nettools}/bin/hostname`|g' \
               "$file"
    done
  '';

  meta = with stdenv.lib; {
    description = "Daemon for controlling APC UPSes";
    homepage = http://www.apcupsd.com/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
