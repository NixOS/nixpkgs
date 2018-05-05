{ lib, rustPlatform, fetchFromGitHub, pkgconfig, file, perl, cmake, libgit2, openssl_1_1_0, libssh2, libzip }:
rustPlatform.buildRustPackage rec {
  name = "powerline-rs-${version}";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "jD91mZM2";
    repo = "powerline-rs";
    rev = version;

    sha256 = "11rhirnk8zh4vf00df9cgy9vw5h8n7kgnhjbjbnlpl9i6wal9nvl";
  };

  cargoSha256 = "184s432a6damzvl0lv6jar1iml9dq60r190aqjy44lcg938981zc";

  nativeBuildInputs = [ pkgconfig file perl cmake ];
  buildInputs = [ libgit2 ];
  propagatedBuildInputs = [ openssl_1_1_0 libssh2 libzip ];

  meta = with lib; {
    description = "powerline-shell rewritten in Rust, inspired by powerline-go";
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
