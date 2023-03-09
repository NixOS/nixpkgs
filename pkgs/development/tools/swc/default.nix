{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "swc";
  version = "0.91.19";

  src = fetchCrate {
    pname = "swc_cli";
    inherit version;
    sha256 = "sha256-BzReetAOKSGzHhITXpm+J2Rz8d9Hq2HUagQmfst74Ag=";
  };

  cargoSha256 = "sha256-1U9YLrPYENv9iJobCxtgnQakJLDctWQwnDUtpLG3PGc=";

  buildFeatures = [ "swc_core/plugin_transform_host_native" ];

  meta = with lib; {
    description = "Rust-based platform for the Web";
    homepage = "https://github.com/swc-project/swc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
