{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-crate";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-+TSZ2QstAF8DXsHunV/nQyqF++0bFud1ZWJQEI3JEwc=";
  };

  cargoSha256 = "sha256-KbErgnXG11ngzLVSktuyUAupYs1ZD64z3plKVtzLx1A=";

  meta = with lib; {
    description = "A protoc plugin that generates Cargo crates and include files for `protoc-gen-prost`";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr sitaaax ];
  };
}
