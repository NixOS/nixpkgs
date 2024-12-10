{
  fetchCrate,
  lib,
  rustPlatform,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-crate";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-MtGeU2PnVYPXb3nly2UaryjmjMz1lxcvYDjFiwf58FA=";
  };

  cargoSha256 = "sha256-dcKJRX/iHIWEmBD2nTMyQozxld8b7dhxxB85quPUysg=";

  meta = with lib; {
    description = "A protoc plugin that generates Cargo crates and include files for `protoc-gen-prost`";
    mainProgram = "protoc-gen-prost-crate";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      felschr
      sitaaax
    ];
  };
}
