{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ma9sdt3/uq06BMELwsNadMkiEfstQhA4DAQEPdizZJM=";
  };

  cargoSha256 = "sha256-pJDrwX5uDIrycxtmbds8l4wadZE0RdgmNpMwVkUGJDs=";

  meta = with lib; {
    description = "Protocol Buffers compiler plugin powered by Prost";
    mainProgram = "protoc-gen-prost";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr sitaaax ];
  };
}
