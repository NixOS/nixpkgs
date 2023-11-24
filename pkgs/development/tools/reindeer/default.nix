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
  version = "unstable-2023-11-09";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "66460cb9628864e230f6b30adc49c4b848d2e843";
    sha256 = "sha256-pB68YxLHiNFhW+0PZ+UW39V59aE11CXZH7WXyqgyRIk=";
  };

  cargoSha256 = "sha256-iw+7xsVNpIQIxDAmN878v88k1EYe1FnJPVpGBhyVstA=";

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

