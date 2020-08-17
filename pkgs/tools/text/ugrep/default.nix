{ stdenv, fetchFromGitHub, boost, bzip2, lz4, pcre2, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "ugrep";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z62rqcvcz8iy6ig7y05gn90m0pn99jc0ll9b82kdbr257kz91r1";
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
