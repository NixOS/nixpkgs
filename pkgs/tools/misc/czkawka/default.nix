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
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    sha256 = "sha256-GhZxBNvqrL2B0sTxvKZt1cn8tveg/0GA+rSQs3LbSXQ=";
  };

  cargoSha256 = "sha256-1G3Zf8rIwIWhUvbE3NN1PSl8KfRpsx1h9INJqLymn9U=";

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
