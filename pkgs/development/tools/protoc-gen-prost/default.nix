{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost";
  version = "0.2.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-QTt5mSUe41r2fxrgWj1l6fHC/utMVIgMi2ySsdGyl/Y=";
  };

  cargoSha256 = "sha256-ghXcyxG9zqUOFKGvUza29OgC3XiEtesqsAsfI/lFT08=";

  meta = with lib; {
    description = "Protocol Buffers compiler plugin powered by Prost";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr sitaaax ];
  };
}
