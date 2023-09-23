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
  version = "unstable-2023-09-16";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "3e72020a556320180053d16425d19ffe089916a3";
    sha256 = "sha256-M3yFIcB4Zdjl+xgp40hNj5cWQhxrv8mfMC2dggNxeqY=";
  };

  cargoSha256 = "sha256-608rF338ukoti8Xa+7p84dyG0XNXJFJkuZqNAqqGJj4=";

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

