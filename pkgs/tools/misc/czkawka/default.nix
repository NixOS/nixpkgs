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
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    sha256 = "0mikgnsqxj8dgapr2k7i9i8mmsza15kp4nasyd6l1vp2cqy8aki6";
  };

  cargoSha256 = "009zfy4lk8y51h1wi71mrjp6kc7xnk3r8jlbxvhyqslhqd9w10fv";

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
