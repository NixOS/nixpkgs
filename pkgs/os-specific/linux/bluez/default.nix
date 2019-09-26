{ stdenv, lib, fetchurl, pkgconfig, dbus, glib, alsaLib,
  python3, readline, udev, libical, systemd, json_c,
  enableHealth ? false,
  enableMesh ? false,
  enableMidi ? false,
  enableNfc ? false,
  enableSap ? false,
  enableSixaxis ? false,
  enableWiimote ? false,
}:

stdenv.mkDerivation rec {
  version = "5.51";
  name = "bluez-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.xz";
    sha256 = "1fpbsl9kkfq6mn6n0dg4h0il4c7fzhwhn79gh907k5b2kwszpvgb";
  };

  pythonPath = with python3.pkgs; [
    dbus-python pygobject2 pygobject3 recursivePthLoader
  ];

  buildInputs = [
    dbus glib alsaLib python3 python3.pkgs.wrapPython
    readline udev libical
  ] ++ lib.optional enableSap json_c;

  nativeBuildInputs = [ pkgconfig ];

  outputs = [ "out" "dev" "test" ];

  postConfigure = ''
    substituteInPlace tools/hid2hci.rules \
      --replace /sbin/udevadm ${systemd}/bin/udevadm \
      --replace "hid2hci " "$out/lib/udev/hid2hci "
  '';

  configureFlags = (with stdenv.lib; [
    "--localstatedir=/var"
    "--enable-library"
    "--enable-cups"
    "--enable-pie"
    "--with-dbusconfdir=${placeholder "out"}/share"
    "--with-dbussystembusdir=${placeholder "out"}/share/dbus-1/system-services"
    "--with-dbussessionbusdir=${placeholder "out"}/share/dbus-1/services"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/etc/systemd/user"
    "--with-udevdir=${placeholder "out"}/lib/udev"
    ] ++ optional enableHealth  [ "--enable-health" ]
      ++ optional enableMesh    [ "--enable-mesh" ]
      ++ optional enableMidi    [ "--enable-midi" ]
      ++ optional enableNfc     [ "--enable-nfc" ]
      ++ optional enableSap     [ "--enable-sap" ]
      ++ optional enableSixaxis [ "--enable-sixaxis" ]
      ++ optional enableWiimote [ "--enable-wiimote" ]
  );

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

  makeFlags = "rulesdir=${placeholder "out"}/lib/udev/rules.d";

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
    homepage = http://www.bluez.org/;
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.linux;
    repositories.git = https://git.kernel.org/pub/scm/bluetooth/bluez.git;
  };
}
