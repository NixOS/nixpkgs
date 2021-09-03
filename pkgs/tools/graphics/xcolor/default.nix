{ lib, rustPlatform, fetchFromGitHub, pkg-config, libX11, libXcursor
, libxcb, python3, installShellFiles, makeDesktopItem, copyDesktopItems }:

rustPlatform.buildRustPackage rec {
  pname = "xcolor";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Soft";
    repo = pname;
    rev = version;
    sha256 = "0i04jwvjasrypnsfwdnvsvcygp8ckf1a5sxvjxaivy73cdvy34vk";
  };

  cargoSha256 = "1r2s4iy5ls0svw5ww51m37jhrbvnj690ig6n9c60hzw1hl4krk30";

  nativeBuildInputs = [ pkg-config python3 installShellFiles copyDesktopItems ];

  buildInputs = [ libX11 libXcursor libxcb ];

  desktopItems = [
    (makeDesktopItem {
      name = "XColor";
      exec = "xcolor -s";
      desktopName = "XColor";
      comment = "Select colors visible anywhere on the screen to get their RGB representation";
      icon = "xcolor";
      categories = "Graphics;";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/applications

    installManPage man/xcolor.1
    for x in 16 24 32 48 256 512; do
        install -D -m644 extra/icons/xcolor-''${x}.png $out/share/icons/hicolor/''${x}x''${x}/apps/xcolor.png
    done
  '';

  meta = with lib; {
    description = "Lightweight color picker for X11";
    homepage = "https://github.com/Soft/xcolor";
    maintainers = with lib.maintainers; [ fortuneteller2k ];
    license = licenses.mit;
  };
}
