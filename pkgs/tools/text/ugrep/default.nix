{ stdenv, fetchFromGitHub, boost, bzip2, lz4, pcre2, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "ugrep";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z3l6dm7v5fdki70nmz2qzrzqmkj3lngiwpswqmyygm7v8gvmimv";
  };

  buildInputs = [ boost bzip2 lz4 pcre2 xz zlib ];

  meta = with stdenv.lib; {
    description = "Ultra fast grep with interactive query UI";
    homepage = "https://github.com/Genivia/ugrep";
    maintainers = with maintainers; [ numkem ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
