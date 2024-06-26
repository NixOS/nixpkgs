{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "swc";
  version = "0.91.69";

  env = {
    # swc depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };

  src = fetchCrate {
    pname = "swc_cli";
    inherit version;
    sha256 = "sha256-8zbxE1qkEWeSYt2L5PElZeJPRuK4Yiooy8xDmCD/PYw=";
  };

  cargoSha256 = "sha256-kRsRUOvDMRci3bN5NfhiLCWojNkSuLz3K4BfKfGYc7g=";

  buildFeatures = [ "swc_core/plugin_transform_host_native" ];

  meta = with lib; {
    description = "Rust-based platform for the Web";
    mainProgram = "swc";
    homepage = "https://github.com/swc-project/swc";
    license = licenses.asl20;
    maintainers = with maintainers; [
      dit7ya
      kashw2
    ];
  };
}
