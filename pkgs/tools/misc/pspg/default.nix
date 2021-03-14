{ lib, stdenv, fetchFromGitHub, gnugrep, ncurses, pkg-config, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "sha256-1udmtstmTmoW45tvDSVQPoMymw5YRKMls1CmWnqIaNE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gnugrep ncurses readline postgresql ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jlesquembre ];
  };
}
