{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "swc";
  version = "0.91.67";

  env = {
    # swc depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };

  src = fetchCrate {
    pname = "swc_cli";
    inherit version;
    sha256 = "sha256-ibNrdMxb1A/QwtK/J/2tbqCxpWssTeFSXrO8oEeEoDA=";
  };

  cargoSha256 = "sha256-puECB7/b2lKTquaDvzd19pYbmY8OeRfbA9u1xMjzl/k=";

  buildFeatures = [ "swc_core/plugin_transform_host_native" ];

  meta = with lib; {
    description = "Rust-based platform for the Web";
    homepage = "https://github.com/swc-project/swc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
