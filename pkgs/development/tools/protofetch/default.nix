{ lib, rustPlatform, fetchCrate, pkg-config, libgit2, openssl, zlib, stdenv
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "protofetch";
  version = "0.0.28";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1DiiBJxdtedfe9uaswcDjK+RkEXxs9n3EPX2ibc2Kis=";
  };

  cargoHash = "sha256-ytJK14JV9ZzZiygwgeDRpfb8F6unQFQWSaKD0u70QTo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl zlib ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A source dependency management tool for Protobuf";
    homepage = "https://crates.io/crates/protofetch";
    license = licenses.asl20;
    maintainers = with maintainers; [ rtimush ];
  };
}
