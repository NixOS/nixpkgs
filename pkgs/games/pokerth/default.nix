{ lib, mkDerivation, fetchFromGitHub, runCommand, fetchpatch, patchutils, qmake, qtbase
, SDL, SDL_mixer, boost, curl, gsasl, libgcrypt, libircclient, protobuf, sqlite
, wrapQtAppsHook
, tinyxml2, target ? "client" }:

let
  hiDPI = fetchpatch {
    url = "https://github.com/pokerth/pokerth/commit/ad8c9cabfb85d8293720d0f14840278d38b5feeb.patch";
    sha256 = "192x3lqvd1fanasb95shdygn997qfrpk1k62k1f4j3s5chkwvjig";
  };

  revertPatch = patch: runCommand "revert-${patch.name}" {} ''
    ${patchutils}/bin/interdiff ${patch} /dev/null > $out
  '';
in

mkDerivation rec {
  pname = "pokerth-${target}";
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

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

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

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL}/include/SDL";

  meta = with lib; {
    homepage = "https://www.pokerth.net";
    description = "Poker game ${target}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ obadz yana ];
    platforms = platforms.all;
  };
}
