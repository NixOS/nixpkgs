{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    rev = "v${version}";
    sha256 = "sha256-siKIE+RHAnZ8Lj3kWg7jEVo5t10dqc59OMrro26ClWo=";
  };

  cargoHash = "sha256-j6WG8pRM6fIvMeXDdkjzRREE9tIug0w+UwWdOmPao4U=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  buildAndTestSubdir = "worker-build";

  # missing some module upstream to run the tests
  doCheck = false;

  meta = with lib; {
    description = "This is a tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project.";
    homepage = "https://github.com/cloudflare/worker-rs";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ happysalada ];
  };
}
