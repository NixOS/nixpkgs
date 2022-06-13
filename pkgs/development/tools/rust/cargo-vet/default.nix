{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vet";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "56b7ce0286944207056435860bef4a67a8c8d881";
    sha256 = "sha256-5zs+w9hnx+aQdBfuUJ/68feZoMAqBV84yFmOIsPim7c=";
  };
  cargoSha256 = "sha256-+PV2+hFIC5C2KrPYJ8zGZZk+yNPU5TByhyLU6cgoJQA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # the tests simply run the cli which requires a lot of networking
  doCheck = false;

  meta = with lib; {
    homepage = "https://mozilla.github.io/cargo-vet/";
    description = "Supply-chain security tool for rust";
    longDescription = ''
      cargo-vet allows that teams to perform relatively-cheap audits, document
      them in a structured way, and make that information available to others.
    '';
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ jk ];
  };
}
