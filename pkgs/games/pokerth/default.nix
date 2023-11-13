{ lib, mkDerivation, fetchFromGitHub, fetchpatch, qmake, qtbase
, SDL, SDL_mixer, boost, curl, gsasl, libgcrypt, libircclient, protobuf, sqlite
, wrapQtAppsHook
, tinyxml2, target ? "client" }:

mkDerivation rec {
  pname = "pokerth-${target}";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "pokerth";
    repo = "pokerth";
    rev = "v${version}";
    hash = "sha256-j4E3VMpaPqX7+hE3wYRZZUeRD//F+K2Gp8oPmJqX5FQ=";
  };

  patches = [
    (fetchpatch {
      name = "pokerth-1.1.2.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/pokerth-1.1.2.patch?h=pokerth&id=7734029cf9c6ef58f42ed873e1b9c3c19eb1df3b";
      hash = "sha256-we2UOCFF5J/Wlji/rJeCHDu/dNsUU+R+bTw83AmvDxs=";
    })
    (fetchpatch {
      name = "pokerth-1.1.2.patch.2019";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/pokerth-1.1.2.patch.2019?h=pokerth&id=7734029cf9c6ef58f42ed873e1b9c3c19eb1df3b";
      hash = "sha256-m6uFPmPC3T9kV7EI1p33vQSi0d/w+YCH0dKjviAphMY=";
    })
    (fetchpatch {
      name = "pokerth-1.1.2.patch.2020";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/pokerth-1.1.2.patch.2020?h=pokerth&id=7734029cf9c6ef58f42ed873e1b9c3c19eb1df3b";
      hash = "sha256-I2qrgLGSMvFDHyUZFWGPGnuecZ914NBf2uGK02X/wOg=";
    })
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
