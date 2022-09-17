{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    rev = "v${version}";
    sha256 = "sha256-oqnYWrytQ3hCf4T/PNIXTs3tW+W8HvuvIulRhdhzsDU=";
  };

  cargoSha256 = "sha256-t35LMyiQl2bsGjNIKqb8sKbrmCLZ0pmoo0qX0buGA+o=";

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
