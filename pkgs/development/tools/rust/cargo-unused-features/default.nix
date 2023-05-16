{ lib
, rustPlatform
, fetchCrate
, curl
, pkg-config
<<<<<<< HEAD
, libgit2_1_5
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-unused-features";
<<<<<<< HEAD
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-gdwIbbQDw/DgBV9zY2Rk/oWjPv1SS/+oFnocsMo2Axo=";
  };

  cargoHash = "sha256-K9I7Eg43BS2SKq5zZ3eZrMkmuHAx09OX240sH0eGs+k=";
=======
  version = "0.1.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-PdSR2nZbRzV2Kg2LNEpI7/Us+r8Gy6XLdUzMLei5r8c=";
  };

  cargoSha256 = "sha256-Y0U5Qzj+S7zoXWemcSfMn0YS7wCAPj+ER0jao+f2B28=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    curl.dev
    pkg-config
  ];

  buildInputs = [
    curl
<<<<<<< HEAD
    libgit2_1_5
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];
=======
    openssl
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    Security
  ]);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool to find potential unused enabled feature flags and prune them";
    homepage = "https://github.com/timonpost/cargo-unused-features";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "unused-features";
  };
}
