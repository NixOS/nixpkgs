{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-serde";
  version = "0.2.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-V2Z6m9y/bBwrr1mgKXKZjVg+LqTe+GalN/AeaICyE64=";
  };

  cargoSha256 = "sha256-l27+Rs4TYIJXZVLj7Tjw8M5+7ivWEY0TXbLtbuzwxLw=";

  meta = with lib; {
    description = "A protoc plugin that generates serde serialization implementations for `protoc-gen-prost`";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr sitaaax ];
  };
}
