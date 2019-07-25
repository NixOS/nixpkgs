{ stdenv, fetchFromGitHub, rustPlatform
, openssh, openssl, pkgconfig, cmake, zlib, curl, libiconv
, CoreFoundation, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rls";
  # with rust 1.x you can only build rls version 1.x.y
  version = "1.35.0";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = pname;
    rev = version;
    sha256 = "1l3fvlgfzri8954nbwqxqghjy5wa8p1aiml12r1lqs92dh0g192f";
  };

  cargoSha256 = "0v96ndys6bv5dfjg01chrqrqjc57qqfjw40n6vppi9bpw0f6wkf5";

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ openssh openssl curl zlib libiconv ]
    ++ (stdenv.lib.optionals stdenv.isDarwin [ CoreFoundation Security ]);

  doCheck = true;
  preCheck = ''
    # client tests are flaky
    rm tests/client.rs
  '';

  meta = with stdenv.lib; {
    description = "Rust Language Server - provides information about Rust programs to IDEs and other tools";
    homepage = https://github.com/rust-lang/rls/;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.all;
  };
}
