{ stdenv, fetchurl, automake, pkgconfig
, cups, zlib, libjpeg, libusb1, pythonPackages, saneBackends, dbus
, polkit, qtSupport ? true, qt4, pyqt4, net_snmp
, withPlugin ? false, substituteAll, makeWrapper
}:

let

  name = "hplip-3.15.6";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/${name}.tar.gz";
    sha256 = "1jbnjw7vrn1qawrjfdv8j58w69q8ki1qkzvlh0nk8nxacpp17i9h";
  };

  hplip_state =
    substituteAll
      {
        src = ./hplip.state;
        # evaluated this way, version is always up-to-date
        version = (builtins.parseDrvName name).version;
      };

  hplip_arch =
    {
      "i686-linux" = "x86_32";
      "x86_64-linux" = "x86_64";
      "arm6l-linux" = "arm32";
      "arm7l-linux" = "arm32";
    }."${stdenv.system}" or (abort "Unsupported platform ${stdenv.system}");

  plugin = fetchurl {
    url = "http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/${name}-plugin.run";
    sha256 = "1rymxahz12s1s37rri5qyvka6q0yi0yai08kgspg24176ry3a3fx";
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
      # Wrap the user-facing Python scripts in /bin without turning the ones
      # in /share into shell scripts (they need to be importable).
      # Complicated by the fact that /bin contains just symlinks to /share.
      for bin in $out/bin/*; do
        py=`readlink -m $bin`
        rm $bin
        cp $py $bin
        wrapPythonProgramsIn $bin "$out $pythonPath"
        sed -i "s@$(dirname $bin)/[^ ]*@$py@g" $bin
      done

      # Remove originals. Knows a little too much about wrapPythonProgramsIn.
      rm -f $out/bin/.*-wrapped

      wrapPythonPrograms $out/lib "$out $pythonPath"
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
      net_snmp
    ] ++ stdenv.lib.optional qtSupport qt4;
  nativeBuildInputs = [
    pkgconfig
  ];

  pythonPath = with pythonPackages; [
      dbus
      pillow
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
    platforms = [ "i686-linux" "x86_64-linux" "armv6l-linux" "armv7l-linux" ];
    maintainers = with maintainers; [ ttuegel jgeerds nckx ];
  };
}
