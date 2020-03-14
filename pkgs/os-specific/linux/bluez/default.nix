{ stdenv, fetchurl, pkgconfig, dbus, glib, alsaLib,
  python3, readline, udev, libical, systemd, fetchpatch,
  enableWiimote ? false, enableMidi ? false, enableSixaxis ? false }:

stdenv.mkDerivation rec {
  name = "bluez-5.50";

  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.xz";
    sha256 = "048r91vx9gs5nwwbah2s0xig04nwk14c5s0vb7qmaqdvighsmz2z";
  };

  pythonPath = with python3.pkgs; [
    dbus-python pygobject2 pygobject3 recursivePthLoader
  ];

  buildInputs = [
    dbus glib alsaLib python3 python3.pkgs.wrapPython
    readline udev libical
  ];

  nativeBuildInputs = [ pkgconfig ];

  outputs = [ "out" "dev" "test" ];

  patches = [
    ./bluez-5.37-obexd_without_systemd-1.patch
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/bluetooth/bluez.git/patch/?id=1880b299086659844889cdaf687133aca5eaf102";
      name = "CVE-2018-10910-1.patch";
      sha256 = "17spsxza27gif8jpxk7360ynvwii1llfdfwg35rwywjjmvww0qj4";
    })
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/bluetooth/bluez.git/patch/?id=9213ff7642a33aa481e3c61989ad60f7985b9984";
      name = "CVE-2018-10910-2.patch";
      sha256 = "0j7klbhym64yhn86dbsmybqmwx47bviyyhx931izl1p29z2mg8hn";
    })
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/bluetooth/bluez.git/patch/?id=8cdbd3b09f29da29374e2f83369df24228da0ad1";
      name = "CVE-2020-0556-1.patch";
      sha256 = "1lqbarf0z8bi82fd6b7nviw1ifnfxc08z25bqxqf0i4i87yfiz8x";
    })
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/bluetooth/bluez.git/patch/?id=3cccdbab2324086588df4ccf5f892fb3ce1f1787";
      name = "CVE-2020-0556-2.patch";
      sha256 = "1gm50dzrs2qmzdpsg5f71bygacai5dcvadia6wf9shmjjlxb7l4w";
    })
  ];

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
    "--with-dbusconfdir=$(out)/etc"
    "--with-dbussystembusdir=$(out)/share/dbus-1/system-services"
    "--with-dbussessionbusdir=$(out)/share/dbus-1/services"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-systemduserunitdir=$(out)/etc/systemd/user"
    "--with-udevdir=$(out)/lib/udev"
    ] ++ optional enableWiimote [ "--enable-wiimote" ]
      ++ optional enableMidi    [ "--enable-midi" ]
      ++ optional enableSixaxis [ "--enable-sixaxis" ]);

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

  makeFlags = "rulesdir=$(out)/lib/udev/rules.d";

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
