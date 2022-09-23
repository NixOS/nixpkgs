{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreFoundation, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    sha256 = "sha256-dxy46ls0n7j2uax+djqB9Zy/uGgV37w5K1Zc8Wzd1Vc=";
  };

  cargoSha256 = "sha256-2Q4pGnMo4FiPPGz2XXOv6+zB5DxHA8oEqztidO2Vvyw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    CoreServices
  ];

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    license = with licenses; [ mpl20 ];
    # all tests fail with:
    # thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: "tests run with disabled concurrency, automatic snapshot name generation is not supported.  Consider using the \"backtrace\" feature of insta which tries to recover test names from the call stack."', /private/tmp/nix-build-cargo-modules-0.5.9.drv-0/cargo-modules-0.5.9-vendor.tar.gz/insta/src/runtime.rs:908:22
    broken = (stdenv.isDarwin && stdenv.isx86_64);
    maintainers = with maintainers; [ figsoda rvarago ];
  };
}
