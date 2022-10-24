{ lib
, fetchFromGitHub
, rustPlatform
}:

let
  owner = "taiki-e";
  repo = "cargo-llvm-cov";
in

rustPlatform.buildRustPackage rec {
  pname = repo;
  version = "0.5.0";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    sha256 = "sha256-2O0MyL4SF/2AUpgWYUDWQ5dDpa84pwmnKGtAaWi5bwQ=";
  };

  cargoLock.lockFile = ./Cargo.lock;
  postPatch = "cp ${./Cargo.lock} Cargo.lock";

  # Skip tests that require `llvm-tools-preview` to be installed since it's not
  # packaged in nixpkgs (yet?)
  checkFlags = lib.concatStringsSep " " [
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

  meta = with lib; {
    description = "Cargo subcommand to easily use LLVM source-based code coverage (-C instrument-coverage)";
    longDescription = ''
      In order for this to work, you need to have the `llvm-tools-preview` component installed. Generally, this is done through either `rustup` or a Nix library/flake.
    '';
    homepage = "https://github.com/${owner}/${repo}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ CobaltCause ];
  };
}
