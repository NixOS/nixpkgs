{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, cairo
, pango
, atk
, gdk-pixbuf
<<<<<<< HEAD
, gtk4
, wrapGAppsHook
=======
, gtk3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "szyszka";
<<<<<<< HEAD
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "szyszka";
    rev = version;
    hash = "sha256-LkXGKDFKaY+mg53ZEO4h2br/4eRle/QbSQJTVEMpAoY=";
  };

  cargoHash = "sha256-WJR1BogNnQoZeOt5yBFzjYNZS8OmE84R1FbQpHTb7V0=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
=======
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = pname;
    rev = version;
    sha256 = "sha256-TQwDvkWWlk09kVVaVI56isJi+X9UXWnoz+2PVyK9BGc=";
  };

  cargoSha256 = "sha256-2uyMA2nIOPkc5+qImFn3eUVq2AxHu3Xj91TpkKswjao=";

  nativeBuildInputs = [
    pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    glib
    cairo
    pango
    atk
    gdk-pixbuf
<<<<<<< HEAD
    gtk4
=======
    gtk3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "A simple but powerful and fast bulk file renamer";
    homepage = "https://github.com/qarmin/szyszka";
<<<<<<< HEAD
    license = licenses.mit;
=======
    license = with licenses; [ mit ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ kranzes ];
  };
}
