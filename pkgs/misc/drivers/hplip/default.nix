{stdenv, fetchurl, cups, zlib, libjpeg, libusb1, pythonPackages, saneBackends, dbus
, pkgconfig, polkit, qtSupport ? true, qt4, pythonDBus, pyqt4, net_snmp, automake
}:

stdenv.mkDerivation rec {
  name = "hplip-3.14.4";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/${name}.tar.gz";
    sha256 = "1j8h44f8igl95wqypj4rk9awcw513hlps980jmcnkx60xghc4l6f";
  };

  #preBuild=''
  #  makeFlags="V=1 DISABLE_JBIG=1 CUPSFILTER=$out/lib/cups/filter CUPSPPD=$out/share/cups/model"
  #'';

  prePatch = ''
    sed -i s,/etc/sane.d,$out/etc/sane.d/, Makefile.in
    sed -i s,/etc/hp/,$out/etc/hp/, base/g.py
    substituteInPlace Makefile.in \
      --replace "/usr/include/libusb-1.0" "${libusb1}/include/libusb-1.0" \
      --replace "/usr/lib/systemd/system" "$out/lib/systemd/system"
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
    "

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
      libusb1
      pythonPackages.python
      pythonPackages.wrapPython
      saneBackends
      dbus
      pkgconfig
      net_snmp
    ] ++ stdenv.lib.optional qtSupport qt4;

  pythonPath = with pythonPackages; [
      pythonDBus
      pygobject
      recursivePthLoader
    ] ++ stdenv.lib.optional qtSupport pyqt4;

  meta = with stdenv.lib; {
    description = "Print, scan and fax HP drivers for Linux";
    homepage = http://hplipopensource.com/;
    license = "free"; # MIT/BSD/GPL
    platforms = platforms.linux;
  };
}
