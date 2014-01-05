{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "libnl-3.2.23";

  src = fetchurl {
    url = "${meta.homepage}files/${name}.tar.gz";
    sha256 = "1czj2bpb799bih6ighqwbvv9pvbpcw7vmccv9cwavfwcmalwvhlc";
  };

  buildInputs = [ bison flex ];

  meta = {
    homepage = "http://www.infradead.org/~tgr/libnl/";
    description = "Linux NetLink interface library";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
