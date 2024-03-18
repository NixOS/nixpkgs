{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-serde";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-O2Mpft31ZQncqETWzwD73I1nX1Wt5XVHcTJUk5qhRLY=";
  };

  cargoSha256 = "sha256-aUWmNS3jF1I0NLApBn3GMMv6ID9mM/j7r7sPFCsFIuw=";

  meta = with lib; {
    description = "A protoc plugin that generates serde serialization implementations for `protoc-gen-prost`";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr sitaaax ];
  };
}
