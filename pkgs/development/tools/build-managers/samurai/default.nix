{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "samurai";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = pname;
    rev = version;
    sha256 = "0k0amxpi3v9v68a8vc69r4b86xs12vhzm0wxd7f11vap1pnqz2cz";
  };

  makeFlags = [ "DESTDIR=" "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "ninja-compatible build tool written in C";
    homepage = "https://github.com/michaelforney/samurai";
    license = with licenses; [ mit asl20 ]; # see LICENSE
    maintainers = with maintainers; [ dtzWill ];
  };
}

