{ stdenv, fetchFromGitHub, runCommand, fetchpatch, patchutils, qmake, qtbase
, SDL, SDL_mixer, boost, curl, gsasl, libgcrypt, libircclient, protobuf, sqlite
, tinyxml2, target ? "client" }:

with stdenv.lib;

let
  hiDPI = fetchpatch {
    url = https://github.com/pokerth/pokerth/commit/ad8c9cabfb85d8293720d0f14840278d38b5feeb.patch;
    sha256 = "192x3lqvd1fanasb95shdygn997qfrpk1k62k1f4j3s5chkwvjig";
  };

  revertPatch = patch: runCommand "revert-${patch.name}" {} ''
    ${patchutils}/bin/interdiff ${patch} /dev/null > $out
  '';
in

stdenv.mkDerivation rec {
  name = "pokerth-${target}-${version}";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "pokerth";
    repo = "pokerth";
    rev = "f5688e01b0efb37035e3b0e3a432200185b9a0c5";
    sha256 = "0la8d036pbscjnbxf8lkrqjfq8a4ywsfwxil452fhlays6mr19h0";
  };

  patches = [
    (revertPatch hiDPI)
  ];

  postPatch = ''
    for f in *.pro; do
      substituteInPlace $f \
        --replace '$$'{PREFIX}/include/libircclient ${libircclient.dev}/include/libircclient \
        --replace 'LIB_DIRS =' 'LIB_DIRS = ${boost.out}/lib' \
        --replace /opt/gsasl ${gsasl}
    done
  '';

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    SDL
    SDL_mixer
    boost
    curl
    gsasl
    libgcrypt
    libircclient
    protobuf
    qtbase
    sqlite
    tinyxml2
  ];

  qmakeFlags = [
    "CONFIG+=${target}"
    "pokerth.pro"
  ];

  NIX_CFLAGS_COMPILE = "-I${SDL.dev}/include/SDL";

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.pokerth.net;
    description = "Poker game ${target}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ obadz yegortimoshenko ];
    platforms = platforms.all;
  };
}
