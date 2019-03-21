{ stdenv, fetchurl, libXt, libXpm, libXext, imake, gccmakedep }:

stdenv.mkDerivation rec {

  version = "1.42";
  name = "xsnow-${version}";

  src = fetchurl {
    url = "https://janswaal.home.xs4all.nl/Xsnow/${name}.tar.gz";
    sha256 = "06jnbp88wc9i9dbmy7kggplw4hzlx2bhghxijmlhkjlizgqwimyh";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [
    libXt libXpm libXext
  ];

  makeFlags = [ "BINDIR=$(out)/bin" "MANPATH=$(out)/share/man" ];

  meta = {
    description = "An X-windows application that will let it snow on the root, in between and on windows";
    homepage = http://janswaal.home.xs4all.nl/Xsnow/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.robberer ];
  };
}
