{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lr";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "0mpaqn0zfhxdf9wzs1wgdd29bjcyl3rgfdlqbwhiwcy2h3vy2h8s";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/chneukirchen/lr;
    description = "List files recursively";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vika_nezrimaya ];
  };
}
