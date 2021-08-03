{ stdenv
, lib
, fetchurl
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
, systemd
, udev
}: let
  pythonPath = with python3.pkgs; [
    dbus-python
    pygobject3
    recursivePthLoader
  ];
in stdenv.mkDerivation rec {
  pname = "bluez";
  version = "5.60";

  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${pname}-${version}.tar.xz";
    sha256 = "sha256-cQmZWA0B7lnsWF5efAf9lO3e3AAaom/nRkxUb52UUwQ=";
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

  outputs = [ "out" "dev" ] ++ lib.optional doCheck "test";

  postPatch = ''
    substituteInPlace tools/hid2hci.rules \
      --replace /sbin/udevadm ${systemd}/bin/udevadm \
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
  ];

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = [ "statedir=$(TMPDIR)/var/lib/bluetooth" ];

  makeFlags = [ "rulesdir=${placeholder "out"}/lib/udev/rules.d" ];

  doCheck = stdenv.hostPlatform.isx86_64;

  postInstall = lib.optionalString doCheck ''
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
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Bluetooth support for Linux";
    homepage = "http://www.bluez.org/";
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.linux;
    repositories.git = "https://git.kernel.org/pub/scm/bluetooth/bluez.git";
  };
}
