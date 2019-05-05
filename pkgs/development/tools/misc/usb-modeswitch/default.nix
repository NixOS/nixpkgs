{ stdenv, lib, fetchurl, pkgconfig, makeWrapper
, libusb1, tcl, utillinux, coreutils, bash }:

stdenv.mkDerivation rec {
  name = "usb-modeswitch-${version}";
  version = "2.5.2";

  src = fetchurl {
    url    = "http://www.draisberghof.de/usb_modeswitch/${name}.tar.bz2";
    sha256 = "19ifi80g9ns5dmspchjvfj4ykxssq9yrci8m227dgb3yr04srzxb";
  };

  patches = [ ./configurable-usb-modeswitch.patch ];

  # Remove attempts to write to /etc and /var/lib.
  postPatch = ''
    sed -i \
      -e '/^\tinstall .* usb_modeswitch.conf/s,$(ETCDIR),$(out)/etc,' \
      -e '\,^\tinstall -d .*/var/lib/usb_modeswitch,d' \
      Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=/etc"
    "USE_UPSTART=false"
    "USE_SYSTEMD=true"
    "SYSDIR=$(out)/lib/systemd/system"
    "UDEVDIR=$(out)/lib/udev"
  ];

  postFixup = ''
    wrapProgram $out/bin/usb_modeswitch_dispatcher \
      --set PATH ${lib.makeBinPath [ utillinux coreutils bash ]}
  '';

  buildInputs = [ libusb1 tcl ];
  nativeBuildInputs = [ pkgconfig makeWrapper ];

  meta = with stdenv.lib; {
    description = "A mode switching tool for controlling 'multi-mode' USB devices";
    license = licenses.gpl2;
    maintainers = with maintainers; [ marcweber peterhoeg ];
    platforms = platforms.linux;
  };
}
