{ stdenv, fetchurl, pkgconfig, libzip, glib, libusb1, libftdi1, check
, libserialport, librevisa, doxygen, glibmm, python
}:

let
  common = {version, sha256}: stdenv.mkDerivation rec {
    inherit version;
    name = "libsigrok-${version}";

    src = fetchurl {
      url = "http://sigrok.org/download/source/libsigrok/${name}.tar.gz";
      inherit sha256;
    };

    firmware = fetchurl {
      url = "http://sigrok.org/download/binary/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-bin-0.1.3.tar.gz";
      sha256 = "1qr02ny97navqxr56xq1a227yzf6h09m8jlvc9bnjl0bsk6887bl";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ libzip glib libusb1 libftdi1 check libserialport
      librevisa doxygen glibmm python
    ];

    postInstall = ''
      mkdir -p "$out/share/sigrok-firmware/"
      tar --strip-components=1 -xvf "${firmware}" -C "$out/share/sigrok-firmware/"
    '';

    meta = with stdenv.lib; {
      description = "Core library of the sigrok signal analysis software suite";
      homepage = http://sigrok.org/;
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = [ maintainers.bjornfor ];
    };
  };
in {
  libsigrok_0_3 = common {
    version = "0.3.0";
    sha256 = "0l3h7zvn3w4c1b9dgvl3hirc4aj1csfkgbk87jkpl7bgl03nk4j3";
  };
  libsigrok_0_5 = common {
    version = "0.5.0";
    sha256 = "197kr5ip98lxn7rv10zs35d1w0j7265s0xvckx0mq2l8kdvqd32c";
  };
}