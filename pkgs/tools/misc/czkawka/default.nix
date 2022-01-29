{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, cairo
, pango
, gdk-pixbuf
, atk
, gtk3
, testVersion
, czkawka
}:

rustPlatform.buildRustPackage rec {
  pname = "czkawka";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    sha256 = "sha256-UIgyKWMVSKAgUNqfxFYSfP+l9x52XAzrXr1nnfKub9I=";
  };

  cargoSha256 = "sha256-jPrkNKFmdVk3LEa20jtXSx+7S98fSrX7Rt/lexC0Gwo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    cairo
    pango
    gdk-pixbuf
    atk
    gtk3
  ];

  passthru.tests.version = testVersion {
    package = czkawka;
    command = "czkawka_cli --version";
  };

  meta = with lib; {
    description = "A simple, fast and easy to use app to remove unnecessary files from your computer";
    homepage = "https://github.com/qarmin/czkawka";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto _0x4A6F ];
  };
}
