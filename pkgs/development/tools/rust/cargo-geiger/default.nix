{ stdenv, lib, fetchFromGitHub
, rustPlatform, pkgconfig, openssl
# darwin dependencies
, Security, CoreFoundation, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "anderejd";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0yn4m94bklxyg0cxzhqm1m976z66rbi58ri1phffvqz457mxj3hk";
  };

  cargoSha256 = "0608wvbdw4i9pp3x6dgny186if6bzlbivkvfd5lfp1x1f53534za";

  # Multiple tests require internet connectivity, so they are disabled here.
  # If we ever get cargo-insta (https://crates.io/crates/insta) in tree,
  # we might be able to run these with something like
  # `cargo insta review` in the `preCheck` phase.
  checkPhase = ''
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
    homepage = https://github.com/anderejd/cargo-geiger;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ evanjs ];
    platforms = platforms.all;
  };
}
