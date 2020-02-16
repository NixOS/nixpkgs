{lib, rustPlatform, fetchFromGitHub, fetchurl, SDL2, makeWrapper, makeDesktopItem}:

let
  desktopFile = makeDesktopItem {
    name = "system-syzygy";
    exec = "%out%/bin/syzygy";
    comment = "A puzzle game";
    desktopName = "System Syzygy";
    categories = "Game;";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "system-syzygy";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mdsteele";
    repo = "syzygy";
    rev = "5ba148fed7aae14bf35108d7303e4194e8ffe5e8";
    sha256 = "07mzwx8ql33q865snnw4gm3dgf0mnm60lnq1f5fgas2yjy9g9vwa";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ SDL2 ];

  cargoSha256 = "001cwdq8zxji56yahwfsydi7s0j7c5zsip60lxk3qmn078wcipdp";

  postInstall = ''
    mkdir -p $out/share/syzygy/
    cp -r ${src}/data/* $out/share/syzygy/
    wrapProgram $out/bin/syzygy --set SYZYGY_DATA_DIR $out/share/syzygy
    mkdir -p $out/share/applications
    substituteAll ${desktopFile}/share/applications/system-syzygy.desktop $out/share/applications/system-syzygy.desktop
  '';


  meta = with lib; {
    description = "A story and a puzzle game, where you solve a variety of puzzle";
    homepage = "https://mdsteele.games/syzygy";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.marius851000 ];
  };
}
