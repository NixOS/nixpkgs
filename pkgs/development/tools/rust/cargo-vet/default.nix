{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vet";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = version;
    sha256 = "sha256-+Qbq3EARedsaPtSTfR/UCC/1p0b/QmvriG2AIyx8coo=";
  };

  cargoSha256 = "sha256-Vij4vq+04fLpbcDpYVMBVl3QNVZprUYcVLB28mrjUOg=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # the test_project tests require internet access
  checkFlags = [
    "--skip=test_project"
  ];

  meta = with lib; {
    description = "A tool to help projects ensure that third-party Rust dependencies have been audited by a trusted source";
    homepage = "https://mozilla.github.io/cargo-vet";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda jk ];
  };
}
