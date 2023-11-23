{ lib
, stdenv
, fetchFromGitHub
, curl
, iup
}:

stdenv.mkDerivation rec {
  pname = "sgdboop";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "SteamGridDB";
    repo = "SGDBoop";
    rev = "v${version}";
    hash = "sha256-bdSzTwObMEBe1pHTDwXeJ3GXmOwwFp4my7qTmifX218=";
  };

  makeFlags = [
    # Makefile copies a bundled libiup.so, so put it somewhere it won't be found
    "USER_LIB_PATH=ignored"

    # The Flakepak install just copies things to /app - otherwise wants to do things with XDG
    "FLATPAK_ID=fake"
  ];

  postPatch = ''
    sed -i "s|Exec=|Exec=$out/bin/|" linux-release/com.steamgriddb.SGDBoop.desktop
    sed -i "s|/app/|$out/|g" Makefile
  '';

  postInstall = ''
    rm -r "$out/share/metainfo"
  '';

  buildInputs = [ curl iup ];

  meta = {
    description = "A program used for applying custom artwork to Steam, using SteamGridDB";
    homepage = "https://github.com/SteamGridDB/SGDBoop/";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = [ lib.maintainers.puffnfresh ];
    mainProgram = "SGDBoop";
    platforms = lib.platforms.linux;
  };
}
