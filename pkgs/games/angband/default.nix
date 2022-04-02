{ lib, stdenv, fetchFromGitHub, autoreconfHook, ncurses5 }:

stdenv.mkDerivation rec {
  pname = "angband";
  version = "4.2.4";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "sha256-Fp3BGCZYYdQCKXOLYsT4zzlibNRlbELZi26ofrbGGPQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses5 ];
  installFlags = [ "bindir=$(out)/bin" ];

  meta = with lib; {
    homepage = "https://angband.github.io/angband";
    description = "A single-player roguelike dungeon exploration game";
    maintainers = [ maintainers.chattered ];
    license = licenses.gpl2;
  };
}
