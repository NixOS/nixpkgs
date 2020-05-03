{ stdenv
, lib
, fetchurl
, alsaLib
, dbus
, glib
, json_c
, libical
, pkgconfig
, python3
, readline
, systemd
, udev

, enableA2dp                        ? false
, enableAndroid                     ? false
, enableAutoImageBase               ? false
, enableAvrcp                       ? false
, enableBacktrace                   ? false
, enableBtpclient                   ? false
, enableClient                      ? false
, enableCups                        ? true
, enableDatafiles                   ? false
, enableDebug                       ? false
, enableDependencyTracking          ? false
, enableDeprecated                  ? false
, enableExperimental                ? true
, enableExternalEll                 ? false
, enableHealth                      ? true
, enableHid                         ? false
, enableHog                         ? false
, enableLibrary                     ? true
, enableLibtoolLock                 ? false
, enableLogger                      ? false
, enableMaintainerMode              ? false
, enableManpages                    ? false
, enableMesh                        ? true
, enableMidi                        ? false
, enableMonitor                     ? false
, enableNetwork                     ? false
, enableNfc                         ? true
, enableObex                        ? false
, enableOptimization                ? false
, enablePie                         ? true
, enableSap                         ? true
, enableSilentRules                 ? false
, enableSixaxis                     ? true
, enableSystemd                     ? false
, enableTest                        ? false
, enableTesting                     ? false
, enableThreads                     ? false
, enableTools                       ? false
, enableUdev                        ? false
, enableWiimote                     ? true
}:

let
  configEnableFlag = flag : ( enabled : if enabled then "--enable-" + flag else "" );
in
  stdenv.mkDerivation rec {
    pname = "bluez";
    version = "5.53";

    src = fetchurl {
      url = "mirror://kernel/linux/bluetooth/${pname}-${version}.tar.xz";
      sha256 = "1g1qg6dz6hl3csrmz75ixr12lwv836hq3ckb259svvrg62l2vaiq";
    };

    pythonPath = with python3.pkgs; [
      dbus-python
      pygobject3
      recursivePthLoader
    ];

    buildInputs = [
      alsaLib
      dbus
      glib
      json_c
      libical
      python3
      readline
      udev
    ];

    nativeBuildInputs = [
      pkgconfig
      python3.pkgs.wrapPython
    ];

    outputs = [ "out" "dev" "test" ];

    postPatch = ''
      substituteInPlace tools/hid2hci.rules \
        --replace /sbin/udevadm ${systemd}/bin/udevadm \
        --replace "hid2hci " "$out/lib/udev/hid2hci "

      mkdir -p $out/var/lib
    '';

    configureFlags = [
      "--localstatedir=/var"
      "--with-dbusconfdir=${placeholder "out"}/share"
      "--with-dbussystembusdir=${placeholder "out"}/share/dbus-1/system-services"
      "--with-dbussessionbusdir=${placeholder "out"}/share/dbus-1/services"
      "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
      "--with-systemduserunitdir=${placeholder "out"}/etc/systemd/user"
      "--with-udevdir=${placeholder "out"}/lib/udev"
      
      (configEnableFlag "a2dp"                enableA2dp)
      (configEnableFlag "android"             enableAndroid)
      (configEnableFlag "avrcp"               enableAvrcp)
      (configEnableFlag "backtrace"           enableBacktrace)
      (configEnableFlag "btpclient"           enableBtpclient)
      (configEnableFlag "client"              enableClient)
      (configEnableFlag "cups"                enableCups)
      (configEnableFlag "datafiles"           enableDatafiles)
      (configEnableFlag "debug"               enableDebug)
      (configEnableFlag "dependency-tracking" enableDependencyTracking)
      (configEnableFlag "deprecated"          enableDeprecated)
      (configEnableFlag "experimental"        enableExperimental)
      (configEnableFlag "external-ell"        enableExternalEll)
      (configEnableFlag "health"              enableHealth)
      (configEnableFlag "hid"                 enableHid)
      (configEnableFlag "hog"                 enableHog)
      (configEnableFlag "library"             enableLibrary)
      (configEnableFlag "libtool-lock"        enableLibtoolLock)
      (configEnableFlag "logger"              enableLogger)
      (configEnableFlag "maintainer-mode"     enableMaintainerMode)
      (configEnableFlag "manpages"            enableManpages)
      (configEnableFlag "mesh"                enableMesh)
      (configEnableFlag "midi"                enableMidi)
      (configEnableFlag "monitor"             enableMonitor)
      (configEnableFlag "network"             enableNetwork)
      (configEnableFlag "nfc"                 enableNfc)
      (configEnableFlag "obex"                enableObex)
      (configEnableFlag "optimization"        enableOptimization)
      (configEnableFlag "pie"                 enablePie)
      (configEnableFlag "sap"                 enableSap)
      (configEnableFlag "silent-rules"        enableSilentRules)
      (configEnableFlag "sixaxis"             enableSixaxis)
      (configEnableFlag "systemd"             enableSystemd)
      (configEnableFlag "testing"             enableTesting)
      (configEnableFlag "threads"             enableThreads)
      (configEnableFlag "tools"               enableTools)
      (configEnableFlag "udev"                enableUdev)
      (configEnableFlag "wiimote"             enableWiimote)
    ];

    # Work around `make install' trying to create /var/lib/bluetooth.
    installFlags = [ "statedir=$out/var/lib/bluetooth" ];

    makeFlags = [ "rulesdir=${placeholder "out"}/lib/udev/rules.d" ];

    doCheck = stdenv.hostPlatform.isx86_64;

    postInstall = ''
      mkdir -p $test/{bin,test}
      cp -a test $test
      pushd $test/test
      for a in \
              simple-agent \
              test-adapter \
              test-device \
              test-thermometer \
              list-devices \
              monitor-bluetooth \
              ; do
        ln -s ../test/$a $test/bin/bluez-$a
      done
      popd
      wrapPythonProgramsIn $test/test "$test/test $pythonPath"

      # for bluez4 compatibility for NixOS
      mkdir $out/sbin
      ln -s ../libexec/bluetooth/bluetoothd $out/sbin/bluetoothd
      ln -s ../libexec/bluetooth/obexd $out/sbin/obexd

      # Add extra configuration
      mkdir $out/etc/bluetooth
      ln -s /etc/bluetooth/main.conf $out/etc/bluetooth/main.conf

      # Add missing tools, ref https://git.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/bluez
      for files in `find tools/ -type f -perm -755`; do
        filename=$(basename $files)
        install -Dm755 tools/$filename $out/bin/$filename
      done
    '';

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "Bluetooth support for Linux";
      homepage = "http://www.bluez.org/";
      license = with licenses; [ gpl2 lgpl21 ];
      platforms = platforms.linux;
      repositories.git = https://git.kernel.org/pub/scm/bluetooth/bluez.git;
    };
  }