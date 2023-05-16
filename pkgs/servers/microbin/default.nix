{ lib
, rustPlatform
<<<<<<< HEAD
, fetchFromGitHub
, pkg-config
, oniguruma
, openssl
, stdenv
, darwin
=======
, fetchCrate
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "microbin";
<<<<<<< HEAD
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "szabodanika";
    repo = "microbin";
    rev = "v${version}";
    hash = "sha256-fsRpqSYDsuV0M6Xar2GVoyTgCPT39dcKJ6eW4YXCkQ0=";
  };

  cargoHash = "sha256-7GSgyh2aJ2f8pozoh/0Yxzbk8Wg3JYuqSy/34ywAc2s=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
  };
=======
  version = "1.2.1";

  # The GitHub source is outdated
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OLg0ejs9nanMNlY0lcnJ/RoRwefrXEaaROwx5aPx4u8=";
  };

  cargoHash = "sha256-XdHP0XruqtyLyGbLHielnmTAc3ZgeIyyZnknO+5k4Xo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tiny, self-contained, configurable paste bin and URL shortener written in Rust";
    homepage = "https://github.com/szabodanika/microbin";
    changelog = "https://github.com/szabodanika/microbin/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
