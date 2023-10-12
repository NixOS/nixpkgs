{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-tonic";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-jgU1XvUxIrZ72dLNPqDGHCONMlHsjW4k4vkO626iqxs=";
  };

  cargoSha256 = "sha256-FrkvL/uJitMkSyOytVSmlwr26yMVM12S2n+EaSw11CE=";

  meta = with lib; {
    description = "A protoc plugin that generates Tonic gRPC server and client code using the Prost code generation engine";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr sitaaax ];
  };
}
