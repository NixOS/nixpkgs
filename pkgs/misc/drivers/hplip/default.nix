{ stdenv, fetchurl, automake, pkgconfig
, cups, zlib, libjpeg, libusb1, pythonPackages, saneBackends, dbus
, polkit, qtSupport ? true, qt4, pythonDBus, pyqt4, net_snmp
, withPlugin ? false, substituteAll
}:

let

  name = "hplip-3.15.2";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/${name}.tar.gz";
    sha256 = "0z7n62vdbr0p0kls1m2sr3nhvkhx3rawcbzd0zdl0lnq8fkyq0jz";
  };

  hplip_state =
    substituteAll
      {
        src = ./hplip.state;
        # evaluated this way, version is always up-to-date
        version = (builtins.parseDrvName name).version;
      };

  plugin = fetchurl {
    url = "http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/${name}-plugin.run";
    sha256 = "0j8z8m3ygwahka7jv3hpzvfz187lh3kzzjhcy7grgaw2k01v5frm";
  };

in

stdenv.mkDerivation {
  inherit name src;

  prePatch = ''
    # HPLIP hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/etc/hp,$out/etc/hp, \
      -e s,/etc/sane.d,$out/etc/sane.d, \
      -e s,/usr/include/libusb-1.0,${libusb1}/include/libusb-1.0, \
      -e s,/usr/share/hal/fdi/preprobe/10osvendor,$out/share/hal/fdi/preprobe/10osvendor, \
      -e s,/usr/lib/systemd/system,$out/lib/systemd/system, \
      -e s,/var/lib/hp,$out/var/lib/hp, \
      {} +
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
          if stdenv.system == "i686-linux" then "x86_32"
          else if stdenv.system == "x86_64-linux" then "x86_64"
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
    license = if withPlugin
      then licenses.unfree
      else with licenses; [ mit bsd2 gpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel jgeerds ];
  };
}
