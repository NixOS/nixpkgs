{ stdenv
, lib
, fetchzip
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-cov";
  version = "0.5.2";

  src = fetchzip {
    url = "https://crates.io/api/v1/crates/${pname}/${version}/download#${pname}-${version}.tar.gz";
    sha256 = "sha256-K6r2YHQq3MEqq9aobJLZBH9COPXpW3TmX1GB1qfnV60=";
  };
  cargoSha256 = "sha256-oMisrS+fDzSdT6JmkAMk8kztOgw2XUOrkhehmd9gxL0=";

  # skip tests which require llvm-tools-preview
  checkFlags = [
    "--skip bin_crate"
    "--skip cargo_config"
    "--skip clean_ws"
    "--skip instantiations"
    "--skip merge"
    "--skip merge_failure_mode_all"
    "--skip no_test"
    "--skip open_report"
    "--skip real1"
    "--skip show_env"
    "--skip virtual1"
  ];

  meta = rec {
    homepage = "https://github.com/taiki-e/${pname}";
    changelog = homepage + "/blob/v${version}/CHANGELOG.md";
    description = "Cargo subcommand to easily use LLVM source-based code coverage";
    longDescription = ''
      In order for this to work, you either need to run `rustup component add llvm-
      tools-preview` or install the `llvm-tools-preview` component using your Nix
      library (e.g. nixpkgs-mozilla, or rust-overlay)
    '';
    license = with lib.licenses; [ asl20 /* or */ mit ];
    maintainers = with lib.maintainers; [ wucke13 ];
  };
}
