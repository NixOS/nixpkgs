{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, cairo
, pango
, gdk-pixbuf
, atk
, gtk4
<<<<<<< HEAD
, Foundation
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wrapGAppsHook4
, gobject-introspection
, xvfb-run
, testers
, czkawka
}:

rustPlatform.buildRustPackage rec {
  pname = "czkawka";
<<<<<<< HEAD
  version = "6.0.0";
=======
  version = "5.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-aMQq44vflpsI66CyaXekMfYh/ssH7UkCX0zsO55st3Y=";
  };

  cargoHash = "sha256-1D87O4fje82Oxyj2Q9kAEey4uEzsNT7kTd8IbNT4WXE=";
=======
    hash = "sha256-3nHsdCndZx7TIbRXhuGdQx8fh8Ff7gYBQyNXIkJ2zPc=";
  };

  cargoHash = "sha256-jBl7+ElK+SEe92qygTocd6R1sgdHf+RpTVJZymhf3mQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    glib
    cairo
    pango
    gdk-pixbuf
    atk
    gtk4
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Foundation
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck
    xvfb-run cargo test
    runHook postCheck
  '';

<<<<<<< HEAD
  doCheck = stdenv.hostPlatform.isLinux
          && (stdenv.hostPlatform == stdenv.buildPlatform);

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.tests.version = testers.testVersion {
    package = czkawka;
    command = "czkawka_cli --version";
  };

  meta = with lib; {
    changelog = "https://github.com/qarmin/czkawka/raw/${version}/Changelog.md";
    description = "A simple, fast and easy to use app to remove unnecessary files from your computer";
    homepage = "https://github.com/qarmin/czkawka";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto _0x4A6F ];
  };
}
