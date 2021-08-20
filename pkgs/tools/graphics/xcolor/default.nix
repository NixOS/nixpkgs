{ lib, rustPlatform, fetchFromGitHub, fetchpatch, pkg-config, libX11, libXcursor
, libxcb, python3, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "XColor";
    exec = "xcolor -s";
    desktopName = "XColor";
    comment =
      "Select colors visible anywhere on the screen to get their RGB representation";
    icon = "xcolor";
    categories = "Graphics;";
  };

in rustPlatform.buildRustPackage rec {
  pname = "xcolor";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Soft";
    repo = pname;
    rev = version;
    sha256 = "0i04jwvjasrypnsfwdnvsvcygp8ckf1a5sxvjxaivy73cdvy34vk";
  };

  cargoSha256 = "1r2s4iy5ls0svw5ww51m37jhrbvnj690ig6n9c60hzw1hl4krk30";

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libX11 libXcursor libxcb ];

  postInstall = ''
    mkdir -p $out/share/applications
    cp "${desktopItem}"/share/applications/* $out/share/applications/

    install -D -m644 -- man/xcolor.1 $out/share/man/man1/xcolor.1
    install -D -m644 -- extra/icons/xcolor-16.png $out/share/icons/hicolor/16x16/apps/xcolor.png
    install -D -m644 -- extra/icons/xcolor-24.png $out/share/icons/hicolor/24x24/apps/xcolor.png
    install -D -m644 -- extra/icons/xcolor-32.png $out/share/icons/hicolor/32x32/apps/xcolor.png
    install -D -m644 -- extra/icons/xcolor-48.png $out/share/icons/hicolor/48x48/apps/xcolor.png
    install -D -m644 -- extra/icons/xcolor-256.png $out/share/icons/hicolor/256x256/apps/xcolor.png
    install -D -m644 -- extra/icons/xcolor-512.png $out/share/icons/hicolor/512x512/apps/xcolor.png
  '';

  meta = with lib; {
    description = "Lightweight color picker for X11";
    homepage = "https://github.com/Soft/xcolor";
    maintainers = with lib.maintainers; [ fortuneteller2k ];
    license = licenses.mit;
  };
}
