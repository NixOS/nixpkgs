{stdenv, fetchurl, lzo}:

stdenv.mkDerivation rec {
  name = "lzop-1.04";
  src = fetchurl {
    url = "https://www.lzop.org/download/${name}.tar.gz";
    sha256 = "0h9gb8q7y54m9mvy3jvsmxf21yx8fc3ylzh418hgbbv0i8mbcwky";
  };

  buildInputs = [ lzo ];

  meta = with stdenv.lib; {
    homepage = http://www.lzop.org;
    description = "Fast file compressor";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
