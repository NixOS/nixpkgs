{ stdenv, fetchurl, substituteAll
, pkgconfig
, cups, zlib, libjpeg, libusb1, python2Packages, sane-backends
, dbus, file, ghostscript, usbutils
, net-snmp, openssl, perl, nettools
, bash, coreutils, utillinux
, withQt5 ? true
, withPlugin ? false
, withStaticPPDInstall ? false
}:

let

  name = "hplip-${version}";
  version = "3.18.5";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/${name}.tar.gz";
    sha256 = "0xb7ga2wgbwjxsss67mjn2y6fmqsfwzmv11ivvfzhnl36lh22hkb";
  };

  plugin = fetchurl {
    url = "https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/${name}-plugin.run";
    sha256 = "1jf74jya071zqvwhy9n0c3007pzgcxydkw7qdh4sx70brly81i7p";
  };

  hplipState = substituteAll {
    inherit version;
    src = ./hplip.state;
  };

  hplipPlatforms = {
    i686-linux    = "x86_32";
    x86_64-linux  = "x86_64";
    armv6l-linux  = "arm32";
    armv7l-linux  = "arm32";
    aarch64-linux = "arm64";
  };

  hplipArch = hplipPlatforms.${stdenv.hostPlatform.system}
    or (throw "HPLIP not supported on ${stdenv.hostPlatform.system}");

  pluginArches = [ "x86_32" "x86_64" "arm32" "arm64" ];

in

assert withPlugin -> builtins.elem hplipArch pluginArches
  || throw "HPLIP plugin not supported on ${stdenv.hostPlatform.system}";

python2Packages.buildPythonApplication {
  inherit name src;
  format = "other";

  buildInputs = [
    libjpeg
    cups
    libusb1
    sane-backends
    dbus
    file
    ghostscript
    net-snmp
    openssl
    perl
    zlib
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  pythonPath = with python2Packages; [
    dbus
    pillow
    pygobject2
    reportlab
    usbutils
    sip
  ] ++ stdenv.lib.optionals withQt5 [
    pyqt5
  ];

  makeWrapperArgs = [ "--prefix" "PATH" ":" "${nettools}/bin" ];

  prePatch = ''
    # HPLIP hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/etc/hp,$out/etc/hp,g \
      -e s,/etc/sane.d,$out/etc/sane.d,g \
      -e s,/usr/include/libusb-1.0,${libusb1.dev}/include/libusb-1.0,g \
      -e s,/usr/share/hal/fdi/preprobe/10osvendor,$out/share/hal/fdi/preprobe/10osvendor,g \
      -e s,/usr/lib/systemd/system,$out/lib/systemd/system,g \
      -e s,/var/lib/hp,$out/var/lib/hp,g \
      -e s,/usr/bin/perl,${perl}/bin/perl,g \
      -e s,/usr/bin/file,${file}/bin/file,g \
      -e s,/usr/bin/gs,${ghostscript}/bin/gs,g \
      -e s,/usr/share/cups/fonts,${ghostscript}/share/ghostscript/fonts,g \
      -e "s,ExecStart=/usr/bin/python /usr/bin/hp-config_usb_printer,ExecStart=$out/bin/hp-config_usb_printer,g" \
      {} +
  '';

  preConfigure = ''
    export configureFlags="$configureFlags
      --with-hpppddir=$out/share/cups/model/HP
      --with-cupsfilterdir=$out/lib/cups/filter
      --with-cupsbackenddir=$out/lib/cups/backend
      --with-icondir=$out/share/applications
      --with-systraydir=$out/xdg/autostart
      --with-mimedir=$out/etc/cups
      --enable-policykit
      ${stdenv.lib.optionalString withStaticPPDInstall "--enable-cups-ppd-install"}
      --disable-qt4
      ${stdenv.lib.optionalString withQt5 "--enable-qt5"}
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

    # Prevent 'ppdc: Unable to find include file "<font.defs>"' which prevent
    # generation of '*.ppd' files.
    # This seems to be a 'ppdc' issue when the tool is run in a hermetic sandbox.
    # Could not find how to fix the problem in 'ppdc' so this is a workaround.
    export CUPS_DATADIR="${cups}/share/cups"
  '';

  enableParallelBuilding = true;

  #
  # Running `hp-diagnose_plugin -g` can be used to diagnose
  # issues with plugins.
  #
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
      chmod 0755 $out/share/hplip/prnt/plugins/$plugin-${hplipArch}.so
      ln -s $out/share/hplip/prnt/plugins/$plugin-${hplipArch}.so \
        $out/share/hplip/prnt/plugins/$plugin.so
    done

    mkdir -p $out/share/hplip/scan/plugins
    for plugin in bb_soap bb_marvell bb_soapht bb_escl; do
      cp $plugin-${hplipArch}.so $out/share/hplip/scan/plugins
      chmod 0755 $out/share/hplip/scan/plugins/$plugin-${hplipArch}.so
      ln -s $out/share/hplip/scan/plugins/$plugin-${hplipArch}.so \
        $out/share/hplip/scan/plugins/$plugin.so
    done

    mkdir -p $out/share/hplip/fax/plugins
    for plugin in fax_marvell; do
      cp $plugin-${hplipArch}.so $out/share/hplip/fax/plugins
      chmod 0755 $out/share/hplip/fax/plugins/$plugin-${hplipArch}.so
      ln -s $out/share/hplip/fax/plugins/$plugin-${hplipArch}.so \
        $out/share/hplip/fax/plugins/$plugin.so
    done

    mkdir -p $out/var/lib/hp
    cp ${hplipState} $out/var/lib/hp/hplip.state
  '';

  # The installed executables are just symlinks into $out/share/hplip,
  # but wrapPythonPrograms ignores symlinks. We cannot replace the Python
  # modules in $out/share/hplip with wrapper scripts because they import
  # each other as libraries. Instead, we emulate wrapPythonPrograms by
  # 1. Calling patchPythonProgram on the original script in $out/share/hplip
  # 2. Making our own wrapper pointing directly to the original script.
  dontWrapPythonPrograms = true;
  preFixup = ''
    buildPythonPath "$out $pythonPath"

    for bin in $out/bin/*; do
      py=$(readlink -m $bin)
      rm $bin
      echo "patching \`$py'..."
      patchPythonScript "$py"
      echo "wrapping \`$bin'..."
      makeWrapper "$py" "$bin" \
          --prefix PATH ':' "$program_PATH" \
          --set PYTHONNOUSERSITE "true" \
          $makeWrapperArgs
    done
  '';

  postFixup = ''
    substituteInPlace $out/etc/hp/hplip.conf --replace /usr $out
    # Patch udev rules:
    # with plugin, they upload firmware to printers,
    # without plugin, they complain about the missing plugin.
    substituteInPlace $out/etc/udev/rules.d/56-hpmud.rules \
      --replace {,${bash}}/bin/sh \
      --replace /usr/bin/nohup "" \
      --replace {,${utillinux}/bin/}logger \
      --replace {/usr,$out}/bin
  '';

  meta = with stdenv.lib; {
    description = "Print, scan and fax HP drivers for Linux";
    homepage = https://developers.hp.com/hp-linux-imaging-and-printing;
    downloadPage = https://sourceforge.net/projects/hplip/files/hplip/;
    license = if withPlugin
      then licenses.unfree
      else with licenses; [ mit bsd2 gpl2Plus ];
    platforms = [ "i686-linux" "x86_64-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ jgeerds ttuegel ];
  };
}
