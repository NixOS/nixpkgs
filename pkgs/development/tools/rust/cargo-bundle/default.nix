{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, darwin
, libxkbcommon
, wayland
}:

rustPlatform.buildRustPackage {
  pname = "cargo-bundle";
  # the latest stable release fails to build on darwin
<<<<<<< HEAD
  version = "unstable-2023-08-18";
=======
  version = "unstable-2023-03-17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "burtonageo";
    repo = "cargo-bundle";
<<<<<<< HEAD
    rev = "c9f7a182d233f0dc4ad84e10b1ffa0d44522ea43";
    hash = "sha256-n+c83pmCvFdNRAlcadmcZvYj+IRqUYeE8CJVWWYbWDQ=";
  };

  cargoHash = "sha256-Ea658jHomktmzXtU5wmd0bRX+i5n46hCvexYxYbjjUc=";
=======
    rev = "eb9fe1b0880c7c0e929a93edaddcb0a61cd3f0d4";
    hash = "sha256-alO+Q9IK5Hz09+TqHWsbjuokxISKQfQTM6QnLlUNydw=";
  };

  cargoHash = "sha256-h+QPbwYTJk6dieta/Q+VAhYe8/YH/Nik6gslzUn0YxI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    wayland
  ];

  meta = with lib; {
    description = "Wrap rust executables in OS-specific app bundles";
    homepage = "https://github.com/burtonageo/cargo-bundle";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
