{stdenv, fetchurl, cmake, python, doxygen, lzma, boost}:
stdenv.mkDerivation rec {
  name = "innoextract-1.4";
  src = fetchurl {
    url = "http://constexpr.org/innoextract/files/${name}.tar.gz";
    sha256 = "1j8wj0ijdnfh0r9qjr7ykp9v3n2yd4qisxln81bl6474w5d4njas";
  };
  buildInputs = [ python doxygen lzma boost ];
  nativeBuildInputs = [ cmake ];
}