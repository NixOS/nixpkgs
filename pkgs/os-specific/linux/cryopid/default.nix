{stdenv, fetchurl, zlibStatic}:

let

  src32 = fetchurl {
    url = http://dagobah.ucc.asn.au/wacky/cryopid-0.5.9.1-i386.tar.gz;
    sha256 = "14175pc87x932c09cl1n5iwc5v1086gd4xpb4pz7d5fvqpaxca3h";
  };

  src64 = fetchurl {
    url = http://dagobah.ucc.asn.au/wacky/cryopid-0.5.9.1-x86_64.tar.gz;
    sha256 = "0y3h9fvb59c8i07das5srhprnsbj1i9m93fp37mzqcjxi2gwjw3b";
  };
  
in

stdenv.mkDerivation {
  name = "cryopid-0.5.9.1";

  src =
    if stdenv.system == "i686-linux" then src32
    else if stdenv.system == "x86_64-linux" then src64
    else abort "unsupported platform for CryoPID";

  buildInputs = [zlibStatic];

  buildPhase = ''
    make -C src ARCH=i386
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp src/freeze $out/bin
  '';

  meta = {
    description = "A process freezer for Linux";
    longDescription = ''
      CryoPID allows you to capture the state of a running process in Linux
      and save it to a file.  This file can then be used to resume the process
      later on, either after a reboot or even on another machines.
    '';
    homepage = http://cryopid.berlios.de;
    license = ''
      Modified BSD license (without advertising clause).  CryoPID ships with
      and links against the dietlibc library, which is distributed under the
      GNU General Public Licence, version 2.
    '';
  };
}
