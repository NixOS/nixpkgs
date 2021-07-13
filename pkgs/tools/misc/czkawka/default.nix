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
}:

rustPlatform.buildRustPackage rec {
  pname = "czkawka";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = pname;
    rev = version;
    sha256 = "sha256-LtGgpfToQUNKM1hmMPW7UrS/n7iyI+dz2vbSo+GOcRg=";
  };

  cargoSha256 = "sha256-ZbyoCo1n4GRBkb5SClby5V51rLN1PnvCHD30TiJU2gY=";

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

  meta = with lib; {
    description = "A simple, fast and easy to use app to remove unnecessary files from your computer";
    homepage = "https://github.com/qarmin/czkawka";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
