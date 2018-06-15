{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ioping-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "koct9i";
    repo = "ioping";
    rev = "v${version}";
    sha256 = "0yn7wgd6sd39zmr5l97zd6sq1ah7l49k1h7dhgx0nv96fa4r2y9h";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Disk I/O latency measuring tool";
    maintainers = with maintainers; [ raskin ndowens ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    homepage = https://github.com/koct9i/ioping;
  };
}
