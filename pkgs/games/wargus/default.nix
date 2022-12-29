{ stdenv, lib, callPackage, fetchFromGitHub
, requireFile, runCommand, p7zip
, cmake, pkg-config, makeWrapper
, zlib, bzip2, libpng
, dialog, python3, cdparanoia, ffmpeg
}:

let
  stratagus = callPackage ./stratagus.nix {};

  dataDownload = requireFile {
    message = ''
      Provide a Warcraft II CD-ROM image.
    '';
    name = "WC2BTDP01.iso";
    sha256 = "0wc4wqb9afxykah8lq1jw0sl564j5gs1shrr67cflfsaiscr4qxm";
  };

  data = runCommand "warcraft2" {
    buildInputs = [ p7zip ];
    meta.license = lib.licenses.unfree;
  } ''
    7z x ${dataDownload}
    cp -r DATA $out
  '';

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

  nativeBuildInputs = [ cmake pkg-config makeWrapper ffmpeg ];
  buildInputs = [ zlib bzip2 libpng ];
  cmakeFlags = [
    "-DSTRATAGUS=${stratagus}/games/stratagus"
    "-DSTRATAGUS_INCLUDE_DIR=${stratagus.src}/gameheaders"
  ];
  postInstall = ''
    makeWrapper $out/games/wargus $out/bin/wargus \
      --prefix PATH : ${lib.makeBinPath [ "$out" ]}
    substituteInPlace $out/share/applications/wargus.desktop \
      --replace $out/games/wargus $out/bin/wargus

    $out/bin/wartool -v -r ${data} $out/share/games/stratagus/wargus
    ln -s $out/share/games/stratagus/wargus/{contrib/black_title.png,graphics/ui/black_title.png}
  '';

  meta = with lib; {
    description = "Importer and scripts for Warcraft II: Tides of Darkness, the expansion Beyond the Dark Portal, and Aleonas Tales";
    homepage = "https://wargus.github.io/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.astro ];
    platforms = platforms.linux;
  };
}
