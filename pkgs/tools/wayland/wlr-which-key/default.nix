{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, cairo
, glib
, libxkbcommon
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "wlr-which-key";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wlr-which-key";
    rev = "v${version}";
    hash = "sha256-GLTbUa5EfpJV7OACTlewAgGjd5Ub0fYHoW8f+EVrT14=";
  };

  cargoHash = "sha256-TtA4Ley5bwymF8Yiqso5fGAwGsT0GRlfAlGS5j4s0Qw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    glib
    libxkbcommon
    pango
  ];

  meta = with lib; {
    description = "Keymap manager for wlroots-based compositors";
    homepage = "https://github.com/MaxVerevkin/wlr-which-key";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xlambein ];
    platforms = platforms.linux;
  };
}
