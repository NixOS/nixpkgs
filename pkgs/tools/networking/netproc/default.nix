{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "netproc";
  version = "unstable-2022-02-11";

  src = fetchFromGitHub {
    owner = "berghetti";
    repo = "netproc";
    rev = "87a10ce31ae150847674ad87ef84ef2fd374b420";
    sha256 = "sha256-YSKDOvqWLCrnP1qjmzMuRgjXiXZ9D4AuxXm/3xzS4gc=";
  };

  buildInputs = [ ncurses ];

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Tool to monitor network traffic based on processes";
    license = licenses.gpl3;
    homepage = "https://github.com/berghetti/netproc";
    platforms = platforms.linux;
    maintainers = [ maintainers.azuwis ];
  };
}
