{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vet";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = version;
    sha256 = "sha256-nBhm6EDs99oKdUxT+N+IC7fY/U0yyeJyr6vbaZaiGSI=";
  };

  cargoSha256 = "sha256-M6CdYL8CDfFH0RaYGel6dC3LxQZzq9YbU8ecH9CWEr8=";

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
