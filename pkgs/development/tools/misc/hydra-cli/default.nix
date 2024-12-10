{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "hydra-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nlewo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fd3swdjx249971ak1bgndm5kh6rlzbfywmydn122lhfi6ry6a03";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  # build fails due to outdated socket2 dependency
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A client for the Hydra CI";
    mainProgram = "hydra-cli";
    homepage = "https://github.com/nlewo/hydra-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lewo ];
  };
}
