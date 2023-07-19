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
  version = "unstable-2023-07-14";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "381fe232bcab77b432e2f29dbbd685e013d19c76";
    sha256 = "sha256-xyoGmleJAZA/tdB2Q11vPe9rcn74SCBPiTR//Cpx1Lw=";
  };

  cargoSha256 = "sha256-GVOkZcleKakXE58LbJthAa5ZWArKkIok/RawLXcwGPw=";

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

