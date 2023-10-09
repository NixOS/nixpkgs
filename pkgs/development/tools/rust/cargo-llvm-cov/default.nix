# If the tests are broken, it's probably for one of two reasons:
#
# 1. The version of llvm used doesn't match the expectations of rustc and/or
#    cargo-llvm-cov. This is relatively unlikely because we pull llvm out of
#    rustc's attrset, so it *should* be the right version as long as this is the
#    case.
# 2. Nixpkgs has changed its rust infrastructure in a way that causes
#    cargo-llvm-cov to misbehave under test. It's likely that even though the
#    tests are failing, cargo-llvm-cov will still function properly in actual
#    use. This has happened before, and is described [here][0] (along with a
#    feature request that would fix this instance of the problem).
#
# For previous test-troubleshooting discussion, see [here][1].
#
# [0]: https://github.com/taiki-e/cargo-llvm-cov/issues/242
# [1]: https://github.com/NixOS/nixpkgs/pull/197478

{ stdenv
, lib
, fetchurl
, fetchFromGitHub
, rustPlatform
, rustc
}:

let
  pname = "cargo-llvm-cov";
  version = "0.5.33";

  owner = "taiki-e";
  homepage = "https://github.com/${owner}/${pname}";

  llvm = rustc.llvmPackages.llvm;

  # Download `Cargo.lock` from crates.io so we don't clutter up Nixpkgs
  cargoLock = fetchurl {
    name = "Cargo.lock";
    url = "https://crates.io/api/v1/crates/${pname}/${version}/download";
    sha256 = "sha256-FDr1Yx2k9yTqnQbtkT8h8DErPe54/lswfbzZKM0Knpk=";
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
    sha256 = "sha256-nlrQIzQc63XdUqWiHFXqjwzzNhgpEba7Rw4VE1d0yBU=";
  };

  # Upstream doesn't include the lockfile so we need to add it back
  postUnpack = ''
    cp ${cargoLock} source/Cargo.lock
  '';

  cargoSha256 = "sha256-etMpCnbdSzaZnlzGlVnTL84VxInYFpuA4xrt8qNqbsQ=";

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
