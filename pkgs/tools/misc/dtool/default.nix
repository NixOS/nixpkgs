{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dtool";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "guoxbin";
    repo = "dtool";
    rev = "v${version}";
    hash = "sha256-m4H+ANwEbK6vGW3oIVZqnqvMiAKxNJf2TLIGh/G6AU4=";
  };

  cargoHash = "sha256-o5Xvc0tnoUgfp5k7EqVuEH9Zyo3C+A+mVqPhMtZCYKw=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];
  # FIXME: remove patch when upstream version of rustc-serialize is updated
  cargoPatches = [ ./rustc-serialize-fix.patch ];

  checkType = "debug";

  meta = with lib; {
    description = "Command-line tool collection to assist development written in RUST";
    homepage = "https://github.com/guoxbin/dtool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linuxissuper ];
    mainProgram = "dtool";
  };
}
