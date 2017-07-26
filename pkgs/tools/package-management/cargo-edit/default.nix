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

  depsSha256 = "1v7ir56j6biximnnhyvadd98azcj3i5hc8aky0am2nf0swq0jimq";

  meta = with stdenv.lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = https://github.com/killercup/cargo-edit;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.all;
  };
}
