{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  makeDesktopItem,
  installShellFiles,
  dejavu_fonts,
  SDL2,
  SDL2_ttf,
  SDL2_image,
}:
let
  pname = "freenukum";
  description = "Clone of the original Duke Nukum 1 Jump'n Run game";

  desktopItem = makeDesktopItem {
    desktopName = pname;
    name = pname;
    exec = pname;
    icon = pname;
    comment = description;
    categories = [
      "Game"
      "ArcadeGame"
      "ActionGame"
    ];
    genericName = pname;
  };

in
rustPlatform.buildRustPackage rec {
  inherit pname;
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "silwol";
    repo = "freenukum";
    rev = "v${version}";
    hash = "sha256-Tk9n2gPwyPin6JZ4RSO8d/+xVpEz4rF8C2eGKwrAXU0=";
  };

  cargoSha256 = "sha256-8RfiObWDqZJg+sjjDBk+sRoS5CiECIdNPH79T+O8e8M=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
  ];

  postPatch = ''
    substituteInPlace src/graphics.rs \
      --replace /usr $out
  '';

  postInstall = ''
    mkdir -p $out/share/fonts/truetype/dejavu
    ln -sf \
      ${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf \
      $out/share/fonts/truetype/dejavu/DejaVuSans.ttf
    mkdir -p $out/share/doc/freenukum
    install -Dm644 README.md CHANGELOG.md $out/share/doc/freenukum/
    installManPage doc/freenukum.6
    install -Dm644 "${desktopItem}/share/applications/"* -t $out/share/applications/
  '';

  meta = with lib; {
    description = "Clone of the original Duke Nukum 1 Jump'n Run game";
    homepage = "https://salsa.debian.org/silwol/freenukum";
    changelog = "https://salsa.debian.org/silwol/freenukum/-/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ _0x4A6F ];
    broken = stdenv.isDarwin;
  };
}
