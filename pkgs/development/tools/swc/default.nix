{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "swc";
  version = "0.91.68";

  env = {
    # swc depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };

  src = fetchCrate {
    pname = "swc_cli";
    inherit version;
    sha256 = "sha256-SLVXh+8oBcq/pKHB5mMLPOR4J3Xlns5eNs8mo2qh/30=";
  };

  cargoSha256 = "sha256-nYMy4OtzNymzan/xZ6Ekx9QL+6AOtciI+sLl4f2Owy0=";

  buildFeatures = [ "swc_core/plugin_transform_host_native" ];

  meta = with lib; {
    description = "Rust-based platform for the Web";
    homepage = "https://github.com/swc-project/swc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya kashw2 ];
  };
}
