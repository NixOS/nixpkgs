{stdenv, fetchurl, cmake, python, doxygen, lzma, boost}:

stdenv.mkDerivation rec {
  name = "innoextract-1.6";

  src = fetchurl {
    url = "http://constexpr.org/innoextract/files/${name}.tar.gz";
    sha256 = "0gh3q643l8qlwla030cmf3qdcdr85ixjygkb7j4dbm7zbwa3yik6";
  };

  buildInputs = [ python doxygen lzma boost ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A tool to unpack installers created by Inno Setup";
    homepage = http://constexpr.org/innoextract/;
    platforms = platforms.linux;
    license = licenses.zlib;
    maintainers = with maintainers; [ abbradar ];
  };
}
