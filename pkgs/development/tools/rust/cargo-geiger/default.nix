{ stdenv, lib, fetchFromGitHub
, rustPlatform, pkg-config, openssl
# testing packages
, cargo-insta
# darwin dependencies
, Security, CoreFoundation, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1z920p8i3gkjadyd6bqjk4i5yr5ds3m3sbcnf7plcqr69dsjr4b8";
  };

  cargoSha256 = "1wf9758gyaxgyajjzy5phirg922n9wv0qmy67zjmxj56ayf0l9lm";

  checkPhase = ''
    ${cargo-insta}/bin/cargo-insta test
  '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv ];
  nativeBuildInputs = [ pkg-config ];

  # FIXME: Use impure version of CoreFoundation because of missing symbols.
  # CFURLSetResourcePropertyForKey is defined in the headers but there's no
  # corresponding implementation in the sources from opensource.apple.com.
  preConfigure = lib.optionalString stdenv.isDarwin ''
    export NIX_CFLAGS_COMPILE="-F${CoreFoundation}/Library/Frameworks $NIX_CFLAGS_COMPILE"
  '';

  meta = with lib; {
    description = "Detects usage of unsafe Rust in a Rust crate and its dependencies";
    homepage = "https://github.com/rust-secure-code/cargo-geiger";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ evanjs ];
  };
}
