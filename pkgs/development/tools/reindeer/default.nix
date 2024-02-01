{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, libiconv
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "reindeer";
  version = "unstable-2024-01-25";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "66cf0b39d0307210a95ff4cf84996a5b73da76c5";
    sha256 = "sha256-F/I1eJVJEs97Rgs94KiSmRJgpNSgQiblMxrYySl5e+g=";
  };

  cargoSha256 = "sha256-Yv/DKW/6/XCbF0o50qPjOlU/3wNBJi/8o5uGRcS0gic=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ] ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "branch" ];
  };

  meta = with lib; {
    description = "Reindeer is a tool which takes Rust Cargo dependencies and generates Buck build rules";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}

