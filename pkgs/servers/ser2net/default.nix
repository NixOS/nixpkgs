{ stdenv, lib, fetchFromGitHub, gensio, libyaml, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ser2net";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "01w82nrgffsfz2c80p4cyppg3bz56d90jm6i6356j0nva3784haw";
  };

  buildInputs = [ pkgconfig autoreconfHook gensio libyaml ];

  meta = with lib; {
    description = "Serial to network connection server";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
