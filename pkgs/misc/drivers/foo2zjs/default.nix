{ stdenv, fetchurl, foomatic-filters, bc, unzip, ghostscript, systemd, vim }:

stdenv.mkDerivation rec {
  name = "foo2zjs-20110210";

  src = fetchurl {
    url = "http://www.loegria.net/mirrors/foo2zjs/${name}.tar.gz";
    sha256 = "0vss8gdbbgxr694xw48rys2qflbnb4sp4gdb1v6z4m9ab97hs5yk";
  };

  buildInputs = [ foomatic-filters bc unzip ghostscript systemd vim ];

  patches = [ ./no-hardcode-fw.diff ];

  makeFlags = [
    "PREFIX=$(out)"
    "APPL=$(out)/share/applications"
    "PIXMAPS=$(out)/share/pixmaps"
    "UDEVBIN=$(out)/bin"
    "UDEVDIR=$(out)/etc/udev/rules.d"
    "UDEVD=${systemd.udev.bin}/sbin/udevd"
    "LIBUDEVDIR=$(out)/lib/udev/rules.d"
    "USBDIR=$(out)/etc/hotplug/usb"
    "FOODB=$(out)/share/foomatic/db/source"
    "MODEL=$(out)/share/cups/model"
  ];

  installFlags = [ "install-hotplug" ];

  postPatch = ''
    touch all-test
    sed -e "/BASENAME=/iPATH=$out/bin:$PATH" -i *-wrapper *-wrapper.in
    sed -e "s@PREFIX=/usr@PREFIX=$out@" -i *-wrapper{,.in}
    sed -e "s@/usr/share@$out/share@" -i hplj10xx_gui.tcl
    sed -e "s@\[.*-x.*/usr/bin/logger.*\]@type logger >/dev/null 2>\&1@" -i *wrapper{,.in}
    sed -e '/install-usermap/d' -i Makefile
    sed -e "s@/etc/hotplug/usb@$out&@" -i *rules*
    sed -e "s@/usr@$out@g" -i hplj1020.desktop
    sed -e "/PRINTERID=/s@=.*@=$out/bin/usb_printerid@" -i hplj1000
  '';

  preInstall = ''
    mkdir -pv $out/{etc/udev/rules.d,lib/udev/rules.d,etc/hotplug/usb}
    mkdir -pv $out/share/foomatic/db/source/{opt,printer,driver}
    mkdir -pv $out/share/cups/model
    mkdir -pv $out/share/{applications,pixmaps}

    mkdir -pv "$out/bin"
    cp -v getweb arm2hpdl "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "ZjStream printer drivers";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
