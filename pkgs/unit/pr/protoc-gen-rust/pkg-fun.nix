{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-rust";
  version = "3.1.0";

  src = fetchCrate {
    inherit version;
    pname = "protobuf-codegen";
    sha256 = "sha256-DaydUuENqmN812BgQmpewRPhkq9lT6+g+VPuytLc25Y=";
  };

  cargoSha256 = "sha256-kzc2Wd+Y3mNmOHxRj5R1LIbvXz5NyGcRnz2e0jdfdPg=";

  cargoBuildFlags = ["--bin" pname];

  nativeBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Protobuf plugin for generating Rust code";
    homepage = "https://github.com/stepancheg/rust-protobuf";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
