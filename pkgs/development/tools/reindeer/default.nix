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
  version = "unstable-2023-10-16";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "f8ffbf2362384e2311a8df458fcf39f44fc491bc";
    sha256 = "sha256-bGxh5bT7sDiIbSKghqlcx1ILPAiffL6lsbWSp5G1CSo=";
  };

  cargoSha256 = "sha256-czzH0DgtK0sZmc670423hcdNQIc30tm+qtY+GA8WZbo=";

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

