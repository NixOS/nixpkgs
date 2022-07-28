{ stdenv, lib, callPackage, fetchFromGitHub
, cmake, pkg-config, makeWrapper
, zlib, bzip2, libpng
, dialog, python3, cdparanoia
}:

let
  stratagus = callPackage ./stratagus.nix {};
in
stdenv.mkDerivation rec {
  pname = "wargus";
  inherit (stratagus) version;

  src = fetchFromGitHub {
    owner = "wargus";
    repo = "wargus";
    rev = "v${version}";
    sha256 = "sha256-yJeMFxCD0ikwVPQApf+IBuMQ6eOjn1fVKNmqh6r760c=";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];
  buildInputs = [ zlib bzip2 libpng ];
  cmakeFlags = [
    "-DSTRATAGUS=${stratagus}/games/stratagus"
    "-DSTRATAGUS_INCLUDE_DIR=${stratagus.src}/gameheaders"
  ];
  postInstall = ''
    makeWrapper $out/games/wargus $out/bin/wargus \
      --prefix PATH : ${lib.makeBinPath [ "$out" cdparanoia python3 ]}
  '';

  meta = with lib; {
    description = "Importer and scripts for Warcraft II: Tides of Darkness, the expansion Beyond the Dark Portal, and Aleonas Tales";
    homepage = "https://wargus.github.io/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.astro ];
    platforms = platforms.linux;
  };
}
