{ stdenv, fetchFromGitHub, rustPlatform
, openssh, openssl, pkgconfig, cmake, zlib, curl, libiconv
, CoreFoundation, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rls";
  # with rust 1.x you can only build rls version 1.x.y
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = pname;
    rev = version;
    sha256 = "1mclv0admxv48pndyqghxc4nf1amhbd700cgrzjshf9jrnffxmrn";
  };

  cargoSha256 = "1yli9540510xmzqnzfi3p6rh23bjqsviflqw95a0fawf2rnj8sin";

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  # rls-rustc links to rustc_private crates
  CARGO_BUILD_RUSTFLAGS = if stdenv.isDarwin then "-C rpath" else null;

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ openssh openssl curl zlib libiconv ]
    ++ (stdenv.lib.optionals stdenv.isDarwin [ CoreFoundation Security ]);

  doCheck = true;
  preCheck = ''
    # client tests are flaky
    rm tests/client.rs
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/rls --version
  '';

  meta = with stdenv.lib; {
    description = "Rust Language Server - provides information about Rust programs to IDEs and other tools";
    homepage = https://github.com/rust-lang/rls/;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.all;
  };
}
