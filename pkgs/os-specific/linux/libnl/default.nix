{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "libnl-3.2.13";

  src = fetchurl {
    url = "${meta.homepage}files/${name}.tar.gz";
    sha256 = "1ydw42lsd572qwrfgws97n76hyvjdpanwrxm03lysnhfxkna1ssd";
  };

  buildInputs = [ bison flex ];

  meta = {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
