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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wlr-which-key";
    rev = "v${version}";
    hash = "sha256-FVpPS5EQ6+xZIBtdS18SdVx0TK9/ikryU9mtm5JvDgk=";
  };

  cargoHash = "sha256-JELvmG2CiknBP3QbaXSl1uj6wEgLaDFVFBuS1l5SUk4=";

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
