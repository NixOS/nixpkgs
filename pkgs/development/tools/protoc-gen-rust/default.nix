{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-rust";
  version = "3.2.0";

  src = fetchCrate {
    inherit version;
    pname = "protobuf-codegen";
    sha256 = "sha256-9Rf7GI/qxoqlISD169TJwUVAdJn8TpxTXDNxiQra2UY=";
  };

  cargoSha256 = "sha256-i1ZIEbU6tw7xA1w+ffD/h1HIkOwVep9wQJys9Bydvv0=";

  cargoBuildFlags = ["--bin" pname];

  nativeBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Protobuf plugin for generating Rust code";
    homepage = "https://github.com/stepancheg/rust-protobuf";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
