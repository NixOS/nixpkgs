{stdenv, fetchurl, xlibs, mesa}:

assert stdenv.system == "i686-linux";

let {

  raw = stdenv.mkDerivation {
    name = "quake3demo-1.11-6";
    src = fetchurl {
      url = ftp://ftp.idsoftware.com/idstuff/quake3/linux/linuxq3ademo-1.11-6.x86.gz.sh;
      md5 = "484610c1ce34272223a52ec331c99d5d";
    };
    builder = ./builder.sh;
  };

  body = stdenv.mkDerivation {
    name = raw.name;
    builder = ./make-wrapper.sh;
    inherit raw mesa;
    inherit (xlibs) libX11 libXext;
  };

}
