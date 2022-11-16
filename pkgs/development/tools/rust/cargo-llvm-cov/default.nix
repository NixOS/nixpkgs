{ stdenv
, lib
, fetchurl
, fetchFromGitHub
, rustPlatform
, rustc
}:

let
  pname = "cargo-llvm-cov";
  version = "0.5.31";

  owner = "taiki-e";
  homepage = "https://github.com/${owner}/${pname}";

  llvm = rustc.llvmPackages.llvm;

  # Download `Cargo.lock` from crates.io so we don't clutter up Nixpkgs
  cargoLock = fetchurl {
    name = "Cargo.lock";
    url = "https://crates.io/api/v1/crates/${pname}/${version}/download";
    sha256 = "sha256-BbrdyJgZSIz6GaTdQv1GiFHufRBSbcoHcqqEmr/HvAM=";
    downloadToTemp = true;
    postFetch = ''
      tar xzf $downloadedFile ${pname}-${version}/Cargo.lock
      mv ${pname}-${version}/Cargo.lock $out
    '';
  };
in

rustPlatform.buildRustPackage {
  inherit pname version;

  # Use `fetchFromGitHub` instead of `fetchCrate` because the latter does not
  # pull in fixtures needed for the test suite
  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wRo94JVn4InkhrMHFSsEvm2FFIxUsltA57sMMOcL8b0=";
  };

  # Upstream doesn't include the lockfile so we need to add it back
  postUnpack = ''
    cp ${cargoLock} source/Cargo.lock
  '';

  cargoSha256 = "sha256-XcsognndhHenYnlJCNMbrNh+S8FX7qxXUjuV1j2qsmY=";

  # `cargo-llvm-cov` reads these environment variables to find these binaries,
  # which are needed to run the tests
  LLVM_COV = "${llvm}/bin/llvm-cov";
  LLVM_PROFDATA = "${llvm}/bin/llvm-profdata";

  meta = {
    inherit homepage;
    changelog = homepage + "/blob/v${version}/CHANGELOG.md";
    description = "Cargo subcommand to easily use LLVM source-based code coverage";
    longDescription = ''
      In order for this to work, you either need to run `rustup component add llvm-
      tools-preview` or install the `llvm-tools-preview` component using your Nix
      library (e.g. fenix or rust-overlay)
    '';
    license = with lib.licenses; [ asl20 /* or */ mit ];
    maintainers = with lib.maintainers; [ wucke13 matthiasbeyer CobaltCause ];

    # The profiler runtime is (currently) disabled on non-Linux platforms
    broken = !(stdenv.isLinux && !stdenv.targetPlatform.isRedox);
  };
}
