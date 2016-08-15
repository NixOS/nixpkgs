{ stdenv, fetchurl, substituteAll
, pkgconfig
, cups, zlib, libjpeg, libusb1, pythonPackages, sane-backends, dbus, usbutils
, net_snmp, openssl, polkit
, bash, coreutils, utillinux
, qtSupport ? true, qt4
, withPlugin ? false
}:

let

  name = "hplip-${version}";
  version = "3.16.5";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/${name}.tar.gz";
    sha256 = "1nay65q1zmx2jxiwn66n7mlr73azacz5097gw98kqqf90dh522f6";
  };

  plugin = fetchurl {
    url = "http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/${name}-plugin.run";
    sha256 = "15qrcd3ndnxri6pfdfmsjyv2f3zfkig80yghs76jbsm106rp8g3q";
  };

  hplipState =
    substituteAll
      {
        inherit version;
        src = ./hplip.state;
      };

  hplipPlatforms =
    {
      "i686-linux"   = "x86_32";
      "x86_64-linux" = "x86_64";
      "armv6l-linux" = "arm32";
      "armv7l-linux" = "arm32";
    };

  hplipArch = hplipPlatforms."${stdenv.system}"
    or (throw "HPLIP not supported on ${stdenv.system}");

  pluginArches = [ "x86_32" "x86_64" ];

in

assert withPlugin -> builtins.elem hplipArch pluginArches
  || throw "HPLIP plugin not supported on ${stdenv.system}";

stdenv.mkDerivation {
  inherit name src;

  buildInputs = [
    libjpeg
    cups
    libusb1
    pythonPackages.python
    pythonPackages.wrapPython
    sane-backends
    dbus
    net_snmp
    openssl
  ] ++ stdenv.lib.optionals qtSupport [
    qt4
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  pythonPath = with pythonPackages; [
    dbus
    pillow
    pygobject
    recursivePthLoader
    reportlab
    usbutils
  ] ++ stdenv.lib.optionals qtSupport [
    pyqt4
  ];

  prePatch = ''
    # HPLIP hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/etc/hp,$out/etc/hp, \
      -e s,/etc/sane.d,$out/etc/sane.d, \
      -e s,/usr/include/libusb-1.0,${libusb1.dev}/include/libusb-1.0, \
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
    "
  '';

  enableParallelBuilding = true;

  postInstall = stdenv.lib.optionalString withPlugin ''
    sh ${plugin} --noexec --keep
    cd plugin_tmp

    cp plugin.spec $out/share/hplip/

    mkdir -p $out/share/hplip/data/firmware
    cp *.fw.gz $out/share/hplip/data/firmware

    mkdir -p $out/share/hplip/data/plugins
    cp license.txt $out/share/hplip/data/plugins

    mkdir -p $out/share/hplip/prnt/plugins
    for plugin in lj hbpl1; do
      cp $plugin-${hplipArch}.so $out/share/hplip/prnt/plugins
      ln -s $out/share/hplip/prnt/plugins/$plugin-${hplipArch}.so \
        $out/share/hplip/prnt/plugins/$plugin.so
    done

    mkdir -p $out/share/hplip/scan/plugins
    for plugin in bb_soap bb_marvell bb_soapht fax_marvell; do
      cp $plugin-${hplipArch}.so $out/share/hplip/scan/plugins
      ln -s $out/share/hplip/scan/plugins/$plugin-${hplipArch}.so \
        $out/share/hplip/scan/plugins/$plugin.so
    done

    mkdir -p $out/var/lib/hp
    cp ${hplipState} $out/var/lib/hp/hplip.state

    mkdir -p $out/etc/sane.d/dll.d
    mv $out/etc/sane.d/dll.conf $out/etc/sane.d/dll.d/hpaio.conf

    rm $out/etc/udev/rules.d/56-hpmud.rules
  '';

  fixupPhase = ''
    # Wrap the user-facing Python scripts in $out/bin without turning the
    # ones in $out /share into shell scripts (they need to be importable).
    # Note that $out/bin contains only symlinks to $out/share.
    for bin in $out/bin/*; do
      py=`readlink -m $bin`
      rm $bin
      cp $py $bin
      wrapPythonProgramsIn $bin "$out $pythonPath"
      sed -i "s@$(dirname $bin)/[^ ]*@$py@g" $bin
    done

    # Remove originals. Knows a little too much about wrapPythonProgramsIn.
    rm -f $out/bin/.*-wrapped

    # Merely patching shebangs in $out/share does not cause trouble.
    for i in $out/share/hplip{,/*}/*.py; do
      substituteInPlace $i \
        --replace /usr/bin/python \
        ${pythonPackages.python}/bin/${pythonPackages.python.executable} \
        --replace "/usr/bin/env python" \
        ${pythonPackages.python}/bin/${pythonPackages.python.executable}
    done

    wrapPythonProgramsIn $out/lib "$out $pythonPath"

    substituteInPlace $out/etc/hp/hplip.conf --replace /usr $out
  '' + stdenv.lib.optionalString (!withPlugin) ''
    # A udev rule to notify users that they need the binary plugin.
    # Needs a lot of patching but might save someone a bit of confusion:
    substituteInPlace $out/etc/udev/rules.d/56-hpmud.rules \
      --replace {,${bash}}/bin/sh \
      --replace {/usr,${coreutils}}/bin/nohup \
      --replace {,${utillinux}/bin/}logger \
      --replace {/usr,$out}/bin
  '';

  meta = with stdenv.lib; {
    description = "Print, scan and fax HP drivers for Linux";
    homepage = http://hplipopensource.com/;
    license = if withPlugin
      then licenses.unfree
      else with licenses; [ mit bsd2 gpl2Plus ];
    platforms = [ "i686-linux" "x86_64-linux" "armv6l-linux" "armv7l-linux" ];
    maintainers = with maintainers; [ jgeerds nckx ];
  };
}
