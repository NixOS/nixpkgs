{ stdenv, fetchurl, automake, pkgconfig
, cups, zlib, libjpeg, libusb1, pythonPackages, saneBackends, dbus
, polkit, qtSupport ? true, qt4, pythonDBus, pyqt4, net_snmp
, withPlugin ? false
}:

stdenv.mkDerivation rec {
  name = "hplip-3.14.4";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/${name}.tar.gz";
    sha256 = "1j8h44f8igl95wqypj4rk9awcw513hlps980jmcnkx60xghc4l6f";
  };

  plugin = fetchurl {
    url = "http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/${name}-plugin.run";
    sha256 = "0k1vpmy7babbm3c5v4dcbhq0jgyr8as722nylfs8zx0dy7kr8874";
  };

  hplip_state = ./hplip.state;

  prePatch = ''
    # HPLIP hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i s,/etc/hp,$out/etc/hp, {} \;
    find . -type f -exec sed -i s,/etc/sane.d,$out/etc/sane.d, {} \;
    find . -type f -exec sed -i s,/usr/include/libusb-1.0,${libusb1}/include/libusb-1.0, {} \;
    find . -type f -exec sed -i s,/usr/share/hal/fdi/preprobe/10osvendor,$out/share/hal/fdi/preprobe/10osvendor, {} \;
    find . -type f -exec sed -i s,/usr/lib/systemd/system,$out/lib/systemd/system, {} \;
    find . -type f -exec sed -i s,/var/lib/hp,$out/var/lib/hp, {} \;
  '';

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
      rulesdir=$out/etc/udev/rules.d
      policykit_dir=$out/share/polkit-1/actions
      policykit_dbus_etcdir=$out/etc/dbus-1/system.d
      policykit_dbus_sharedir=$out/share/dbus-1/system-services
      hplip_confdir=$out/etc/hp
      hplip_statedir=$out/var/lib/hp
    ";
  '';

  postInstall =
    ''
    wrapPythonPrograms
    ''
    + (stdenv.lib.optionalString withPlugin
    (let hplip_arch =
          if builtins.currentSystem == "i686-linux"
            then "x86_32"
            else if builtins.currentSystem == "x86_64-linux"
              then "x86_64"
              else abort "Platform must be i686-linux or x86_64-linux!";
    in
    ''
    sh ${plugin} --noexec --keep
    cd plugin_tmp

    cp plugin.spec $out/share/hplip/

    mkdir -p $out/share/hplip/data/firmware
    cp *.fw.gz $out/share/hplip/data/firmware

    mkdir -p $out/share/hplip/data/plugins
    cp license.txt $out/share/hplip/data/plugins

    mkdir -p $out/share/hplip/prnt/plugins
    for plugin in lj hbpl1; do
      cp $plugin-${hplip_arch}.so $out/share/hplip/prnt/plugins
      ln -s $out/share/hplip/prnt/plugins/$plugin-${hplip_arch}.so \
        $out/share/hplip/prnt/plugins/$plugin.so
    done

    mkdir -p $out/share/hplip/scan/plugins
    for plugin in bb_soap bb_marvell bb_soapht fax_marvell; do
      cp $plugin-${hplip_arch}.so $out/share/hplip/scan/plugins
      ln -s $out/share/hplip/scan/plugins/$plugin-${hplip_arch}.so \
        $out/share/hplip/scan/plugins/$plugin.so
    done

    mkdir -p $out/var/lib/hp
    cp ${hplip_state} $out/var/lib/hp/hplip.state

    mkdir -p $out/etc/sane.d/dll.d
    mv $out/etc/sane.d/dll.conf $out/etc/sane.d/dll.d/hpaio.conf

    rm $out/etc/udev/rules.d/56-hpmud.rules
    ''));

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
      pillow
      pythonDBus
      pygobject
      recursivePthLoader
      reportlab
    ] ++ stdenv.lib.optional qtSupport pyqt4;

  meta = with stdenv.lib; {
    description = "Print, scan and fax HP drivers for Linux";
    homepage = http://hplipopensource.com/;
    license = if withPlugin then licenses.unfree else "free"; # MIT/BSD/GPL
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel ];
  };
}
