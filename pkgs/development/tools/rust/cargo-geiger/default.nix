{ stdenv, lib, fetchFromGitHub
, rustPlatform, pkgconfig, openssl
# darwin dependencies
, Security, CoreFoundation, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "anderejd";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1lm8dx19svdpg99zbpfcm1272n18y63sq756hf6k99zi51av17xc";
  };

  cargoSha256 = "16zvm2y0j7ywv6fx0piq99g8q1sayf3qipd6adrwyqyg8rbf4cw6";

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
