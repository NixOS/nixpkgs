{stdenv, fetchurl, ncurses}:
let
  s = 
  rec {
    baseName = "nudoku";
    version = "1.0.0";
    name = "${baseName}-${version}";
    url = "https://github.com/jubalh/nudoku/releases/download/${version}/${baseName}-${version}.tar.xz";
    sha256 = "0nr2j2z07nxk70s8xnmmpzccxicf7kn5mbwby2kg6aq8paarjm8k";
  };
  buildInputs = [
    ncurses
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preInstall = ''
    mkdir -p {share/man,bin}
  '';
  meta = {
    inherit (s) version;
    description = ''A ncurses based sudoku game'';
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ "Manuel Reinhardt <manuel.reinhardt@neon-cathedral.net>" ];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://github.com/jubalh/nudoku;
  };
}
