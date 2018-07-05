{ stdenv, fetchurl, libusb }:
stdenv.mkDerivation {
  name = "sixpair-2007-04-18";

  src = fetchurl {
    url = http://www.pabr.org/sixlinux/sixpair.c;
    sha256 = "1b0a3k7gs544cbji7n29jxlrsscwfx6s1r2sgwdl6hmkc1l9gagr";
  };

  # hcitool is depricated
  patches = [ ./hcitool.patch ];

  buildInputs = [ libusb ];

  unpackPhase = ''
    cp $src sixpair.c
  '';

  buildPhase = ''
    cc -o sixpair sixpair.c -lusb
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sixpair $out/bin/sixpair
  '';

  meta = {
    description = "Pair with SIXAXIS controllers over USB";
    longDescription = ''
      This command-line utility searches USB buses for SIXAXIS controllers and tells them to connect to a new Bluetooth master.
    '';
    homepage = http://www.pabr.org/sixlinux/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.tomsmeets ];
    platforms = stdenv.lib.platforms.linux;
  };
}
