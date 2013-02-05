{stdenv, fetchurl, cups, zlib, libjpeg, libusb, pythonPackages, saneBackends, dbus
, pkgconfig, polkit, qtSupport ? true, qt4, pythonDBus, pyqt4
}:

stdenv.mkDerivation rec {
  name = "hplip-3.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/${name}.tar.gz";
    sha256 = "0y68s4xm5d0kv7p5j41qq0xglp4vdbjwbrjs89b4a21wwn69hp9g";
  };

  #preBuild=''
  #  makeFlags="V=1 DISABLE_JBIG=1 CUPSFILTER=$out/lib/cups/filter CUPSPPD=$out/share/cups/model"
  #'';

  prePatch = ''
    sed -i s,/etc/sane.d,$out/etc/sane.d/, Makefile.in
    sed -i s,/etc/hp/,$out/etc/hp/, base/g.py
  '';

  # --disable-network-build Until we have snmp

  preConfigure = ''
    export configureFlags="$configureFlags
      --with-cupsfilterdir=$out/lib/cups/filter
      --with-cupsbackenddir=$out/lib/cups/backend
      --with-icondir=$out/share/applications
      --with-systraydir=$out/xdg/autostart
      --with-mimedir=$out/etc/cups
      --enable-policykit
      --disable-network-build"

    export makeFlags="
      halpredir=$out/share/hal/fdi/preprobe/10osvendor
      hplip_statedir=$out/var
      rulesdir=$out/etc/udev/rules.d
      policykit_dir=$out/share/polkit-1/actions
      policykit_dbus_etcdir=$out/etc/dbus-1/system.d
      policykit_dbus_sharedir=$out/share/dbus-1/system-services
      hplip_confdir=$out/etc/hp
    ";
  '';

  postInstall = ''
    wrapPythonPrograms
    '';

  buildInputs = [
      libjpeg
      cups
      libusb
      pythonPackages.python
      pythonPackages.wrapPython
      saneBackends
      dbus
      pkgconfig] ++
    stdenv.lib.optional qtSupport qt4;

  pythonPath = with pythonPackages; [
      pythonDBus
      pyqt4
      pygobject
      recursivePthLoader
    ];

  meta = with stdenv.lib; {
    description = "Print, scan and fax HP drivers for Linux";
    homepage = http://hplipopensource.com/;
    license = "free"; # MIT/BSD/GPL
    platforms = platforms.linux;
  };
}
