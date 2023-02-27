{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, testers
, wizer
}:

rustPlatform.buildRustPackage rec {
  pname = "wizer";
  version = "1.6.0";

  # the crate does not contain files which are necessary for the tests
  # see https://github.com/bytecodealliance/wizer/commit/3a95e27ce42f1fdaef07b52988e4699eaa221e04
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wizer";
    # see https://github.com/bytecodealliance/wizer/pull/62
    rev = "e74c6e59562c4b7edcda506674db8aead878a893";
    sha256 = "sha256-bVxjcb231Ygz+z+8D1U2YQqEdIKsostxISgYt2KecXc=";
  };

  cargoSha256 = "sha256-S9h47aGG5UhwNoOnUHFrtEyByg8iCMC88Cspb/6tb8c=";

  cargoBuildFlags = [ "--bin" pname ];

  buildFeatures = [ "env_logger" "structopt" ];

  # Setting $HOME to a temporary directory is necessary to prevent checks from failing, as
  # the test suite creates a cache directory at $HOME/Library/Caches/BytecodeAlliance.wasmtime.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests = {
    version = testers.testVersion { package = wizer; };
  };

  meta = with lib; {
    description = "The WebAssembly pre-initializer";
    homepage = "https://github.com/bytecodealliance/wizer";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins amesgen ];
  };
}
