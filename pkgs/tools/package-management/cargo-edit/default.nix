{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, zlib, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "cargo-edit-${version}";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${version}";
    sha256 = "16wvix2zkpzl1hhlsvd6mkps8fw5k4n2dvjk9m10gg27pixmiync";
  };

  buildInputs = [ zlib openssl ];

  cargoSha256 = "1m4yb7472g1n900dh3xqvdcywk3v01slj3bkk7bk7a9p5x1kyjfn";

  meta = with stdenv.lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = https://github.com/killercup/cargo-edit;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.all;
    broken = true;
  };
}
