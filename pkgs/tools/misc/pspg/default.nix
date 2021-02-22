{ lib, stdenv, fetchFromGitHub, gnugrep, ncurses, pkg-config, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "sha256-YQrANrCd0nFdn98LfHH/Ishm+fDb12cUAkxlwtZ1ng8=";
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
