{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vet";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "0.3";
    sha256 = "sha256-m+2Rbaa7wtzdUyl8VzrGsxtZPhQMwlrx6okhc4zZNsI=";
  };

  cargoSha256 = "sha256-2Ri/CvTZ/RQqxHSgl05kaCbg0ATJapaFEF6y8fWGSwM=";

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
