{ lib
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, makeWrapper
, rustPlatform
, vulkan-loader
<<<<<<< HEAD
, wayland
, pkg-config
, udev
, v4l-utils
=======
, pkg-config
, udev
, v4l-utils
, llvmPackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "wluma";
<<<<<<< HEAD
  version = "4.2.0";
=======
  version = "4.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-6qZlwjzBPDkr2YHzDYeKQOuoozV7rpl8dojqTTzInqg=";
=======
    sha256 = "sha256-kUYh4RmD4zRI3ZNZWl2oWcO0Ze5czLBXUgPMl/cLW/I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "toml-0.5.9" = "sha256-WUQFF9Hfo3JK65AKAF7qNZex6l7F3N8HXmJlu8cJUEE=";
=======
      "toml-0.5.8" = "sha256-aOq5ERYXP329k1d6z8AS987KlFRRcPZhMHOzxnSRXZg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    v4l-utils
<<<<<<< HEAD
    vulkan-loader
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postInstall = ''
    wrapProgram $out/bin/wluma \
<<<<<<< HEAD
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
=======
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ vulkan-loader ]}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Automatic brightness adjustment based on screen contents and ALS";
    homepage = "https://github.com/maximbaz/wluma";
<<<<<<< HEAD
    changelog = "https://github.com/maximbaz/wluma/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.isc;
    maintainers = with maintainers; [ yshym jmc-figueira ];
    platforms = platforms.linux;
  };
}
