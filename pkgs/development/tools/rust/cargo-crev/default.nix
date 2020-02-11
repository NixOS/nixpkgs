{ stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkgconfig, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "1v7m2yy54jm5mkg9n3wnba1j5ldw6mvk2sgbngx1q240wnc9vbnk";
  };

  cargoSha256 = "09kcvrhklbzjjyqikj9c53w24qy3f6v5hb16ib4fq1s2ia77rgl2";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with stdenv.lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n ];
  };
}
