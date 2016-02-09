{stdenv, fetchurl, cmake, python, doxygen, lzma, boost}:

stdenv.mkDerivation rec {
  name = "innoextract-1.5";

  src = fetchurl {
    url = "http://constexpr.org/innoextract/files/${name}.tar.gz";
    sha256 = "1ks8z8glak63xvqlv7dnmlzkjrwsn81lhybmai2mja6g5jclwngj";
  };

  buildInputs = [ python doxygen lzma boost ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A tool to unpack installers created by Inno Setup";
    homepage = "http://constexpr.org/innoextract/";
    platforms = platforms.linux;
    license = licenses.zlib;
    maintainers = with maintainers; [ abbradar ];
  };
}
