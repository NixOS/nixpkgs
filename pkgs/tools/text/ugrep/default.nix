{ stdenv, fetchFromGitHub, boost, bzip2, lz4, pcre2, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "ugrep";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aps4srdss71p6riixcdk50f2484bmq6p2kg95gcb8wbcv3ad3c9";
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
