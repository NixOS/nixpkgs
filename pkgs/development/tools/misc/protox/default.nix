{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "protox";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-n72Fvdo6LLk8pzYS2/5zk+dbsLRPAm6NZ5DsMRyHCTY=";
  };

  cargoHash = "sha256-wW4UcC3QAtriLEiXPndP+tZATftWP7ySavpIV6cGVCA=";

  buildFeatures = [ "bin" ];

  # tests are not included in the crate source
  doCheck = false;

  meta = with lib; {
    description = "A rust implementation of the protobuf compiler";
    homepage = "https://github.com/andrewhickman/protox";
    changelog = "https://github.com/andrewhickman/protox/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
