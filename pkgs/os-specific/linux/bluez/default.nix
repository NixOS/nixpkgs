{ stdenv
, lib
, fetchurl
, fetchpatch
, alsa-lib
, dbus
, ell
, glib
, json_c
, libical
, docutils
, pkg-config
, python3
, readline
, systemdMinimal
, udev
, withExperimental ? false
}: let
  pythonPath = with python3.pkgs; [
    dbus-python
    pygobject3
    recursivePthLoader
  ];
in stdenv.mkDerivation rec {
  pname = "bluez";
  version = "5.64";

  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${pname}-${version}.tar.xz";
    sha256 = "sha256-rkN+ZbazBwwZi8WwEJ/pzeueqjhzgOIHL53mX+ih3jQ=";
  };

  buildInputs = [
    alsa-lib
    dbus
    ell
    glib
    json_c
    libical
    python3
    readline
    udev
  ];

  nativeBuildInputs = [
    docutils
    pkg-config
    python3.pkgs.wrapPython
  ];

  outputs = [ "out" "dev" "test" ];

  patches = [
    # https://github.com/bluez/bluez/commit/0905a06410d4a5189f0be81e25eb3c3e8a2199c5
    # which fixes https://github.com/bluez/bluez/issues/329
    # and is already merged upstream and not yet in a release.
    (fetchpatch {
      name = "StateDirectory_and_ConfigurationDirectory.patch";
      url = "https://github.com/bluez/bluez/commit/0905a06410d4a5189f0be81e25eb3c3e8a2199c5.patch";
      sha256 = "sha256-MI6yPTiDLHsSTjLvNqtWnuy2xUMYpSat1WhMbeoedSM=";
    })
  ];

  postPatch = ''
    substituteInPlace tools/hid2hci.rules \
      --replace /sbin/udevadm ${systemdMinimal}/bin/udevadm \
      --replace "hid2hci " "$out/lib/udev/hid2hci "
    # Disable some tests:
    # - test-mesh-crypto depends on the following kernel settings:
    #   CONFIG_CRYPTO_[USER|USER_API|USER_API_AEAD|USER_API_HASH|AES|CCM|AEAD|CMAC]
    if [[ ! -f unit/test-mesh-crypto.c ]]; then echo "unit/test-mesh-crypto.c no longer exists"; false; fi
    echo 'int main() { return 77; }' > unit/test-mesh-crypto.c
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--enable-library"
    "--enable-cups"
    "--enable-pie"
    "--enable-external-ell"
    "--with-dbusconfdir=${placeholder "out"}/share"
    "--with-dbussystembusdir=${placeholder "out"}/share/dbus-1/system-services"
    "--with-dbussessionbusdir=${placeholder "out"}/share/dbus-1/services"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/etc/systemd/user"
    "--with-udevdir=${placeholder "out"}/lib/udev"
    "--enable-health"
    "--enable-mesh"
    "--enable-midi"
    "--enable-nfc"
    "--enable-sap"
    "--enable-sixaxis"
    "--enable-btpclient"
    "--enable-hid2hci"
    "--enable-logger"

    # To provide ciptool, sdptool, and rfcomm (unmaintained)
    # superseded by new D-Bus APIs
    "--enable-deprecated"
  ] ++ lib.optional withExperimental "--enable-experimental";


  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = [ "statedir=$(TMPDIR)/var/lib/bluetooth" ];

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
    wrapPythonProgramsIn $test/test "$test/test ${toString pythonPath}"
  '' + ''
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
    install -Dm755 attrib/gatttool $out/bin/gatttool
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Bluetooth support for Linux";
    homepage = "http://www.bluez.org/";
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.linux;
  };
}
