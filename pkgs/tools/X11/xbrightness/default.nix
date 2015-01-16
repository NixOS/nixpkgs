{ stdenv, fetchurl, x11, xlibs }:

stdenv.mkDerivation {

  name = "xbrightness-0.3-mika-akk";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://shallowsky.com/software/xbrightness/xbrightness-0.3-mika-akk.tar.gz;
    sha256 = "2564dbd393544657cdabe4cbf535d9cfb9abe8edddb1b8cdb1ed4d12f358626e";
  };

  buildInputs = [
    xlibs.imake
    xlibs.libX11
    xlibs.libXaw
    xlibs.libXext
    xlibs.libXmu
    xlibs.libXpm
    xlibs.libXxf86vm
  ];

  meta = {
    description = "X11 brigthness and gamma software control";
    homepage = http://shallowsky.com/software;
    license = stdenv.lib.licenses.mit;
  };
}
