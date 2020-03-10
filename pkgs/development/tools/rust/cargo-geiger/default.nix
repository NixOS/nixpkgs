{ stdenv, lib, fetchFromGitHub
, rustPlatform, pkgconfig, openssl
# darwin dependencies
, Security, CoreFoundation, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0kvmjahyx5dcjhry2hkvcshi0lbgipfj0as74a3h3bllfvdfkkg0";
  };

  cargoSha256 = "0v50fkyf0a77l7whxalwnfqfi8lxy82z2gpd0fa0ib80qjla2n5z";
  cargoPatches = [ ./cargo-lock.patch ];

  # Multiple tests require internet connectivity, so they are disabled here.
  # If we ever get cargo-insta (https://crates.io/crates/insta) in tree,
  # we might be able to run these with something like
  # `cargo insta review` in the `preCheck` phase.
  checkPhase = ''
    cd cargo-geiger/tests/snapshots
    for file in *
    do
      mv $file r#$file
    done
    cd -
    cargo test -- \
    --skip test_package::case_2 \
    --skip test_package::case_3 \
    --skip test_package::case_6
  '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv ];
  nativeBuildInputs = [ pkgconfig ];

  # FIXME: Use impure version of CoreFoundation because of missing symbols.
  # CFURLSetResourcePropertyForKey is defined in the headers but there's no
  # corresponding implementation in the sources from opensource.apple.com.
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_CFLAGS_COMPILE="-F${CoreFoundation}/Library/Frameworks $NIX_CFLAGS_COMPILE"
  '';

  meta = with lib; {
    description = "Detects usage of unsafe Rust in a Rust crate and its dependencies.";
    homepage = https://github.com/rust-secure-code/cargo-geiger;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ evanjs ];
    platforms = platforms.all;
  };
}
