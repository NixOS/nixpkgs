{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "samurai";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = pname;
    rev = version;
    sha256 = "1jsxfpwa6q893x18qlvpsiym29rrw5cj0k805wgmk2n57j9rw4f2";
  };

  makeFlags = [ "DESTDIR=" "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "ninja-compatible build tool written in C";
    homepage = "https://github.com/michaelforney/samurai";
    license = with licenses; [ mit asl20 ]; # see LICENSE
    maintainers = with maintainers; [ dtzWill ];
  };
}

