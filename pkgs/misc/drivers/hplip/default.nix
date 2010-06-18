{stdenv, fetchurl, cups, zlib, libjpeg, libusb, python, saneBackends, dbus, pkgconfig
, qtSupport ? false, qt4
}:

stdenv.mkDerivation {
  name = "hplip-3.10.5";

  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/hplip/hplip-3.10.5.tar.gz";
    sha256 = "1lyl9nrdaih64cqw6fa7ivjf7a74bq8zn0gkj1gap47b04my608p";
  };

  #preBuild=''
  #  makeFlags="V=1 DISABLE_JBIG=1 CUPSFILTER=$out/lib/cups/filter CUPSPPD=$out/share/cups/model"
  #'';

  prePatch = ''
    sed -i s,/etc/sane.d,$out/etc/sane.d/, Makefile.in 
  '';

  preConfigure = ''
    export configureFlags="$configureFlags
      --with-cupsfilterdir=$out/lib/cups/filter
      --with-cupsbackenddir=$out/lib/cups/backend
      --with-icondir=$out/share/applications
      --with-systraydir=$out/xdg/autostart
      --with-mimedir=$out/etc/cups
      # Until we have snmp
      --disable-network-build"

    export makeFlags="
      halpredir=$out/share/hal/fdi/preprobe/10osvendor
      hplip_statedir=$out/var
      rulesdir=$out/etc/udev/rules.d
      hplip_confdir=$out/etc/hp
    ";
  '';

  buildInputs = [libjpeg cups libusb python saneBackends dbus pkgconfig] ++
    stdenv.lib.optional qtSupport qt4;

  meta = {
    description = "Print, scan and fax HP drivers for Linux";
    homepage = http://hplipopensource.com/;
    license = "free" # MIT/BSD/GPL
  };
}
