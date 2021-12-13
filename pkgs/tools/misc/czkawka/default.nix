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
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    sha256 = "0p1j5f5jk0cci6bg4jfnnn80gyi9039ni4ma8zwindk7fyn9gpc8";
  };

  cargoSha256 = "1q35c5szavpsnzflw33radg6blzql3sz3jyzyqqz97ac69zns920";

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
