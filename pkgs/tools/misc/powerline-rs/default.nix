{ lib, rustPlatform, fetchFromGitHub, pkgconfig, file, perl, cmake, libgit2, openssl_1_1_0, libssh2, libzip }:
rustPlatform.buildRustPackage rec {
  name = "powerline-rs-${version}";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "jD91mZM2";
    repo = "powerline-rs";
    rev = version;

    sha256 = "0ry1axia78sp9vmn6p119l69sj3dqx2san1k71a5npf60rf4gfkc";
  };

  cargoSha256 = "184s432a6damzvl0lv6jar1iml9dq60r190aqjy44lcg938981zc";

  nativeBuildInputs = [ pkgconfig file perl cmake ];
  buildInputs = [ libgit2 ];
  propagatedBuildInputs = [ openssl_1_1_0 libssh2 libzip ];

  meta = with lib; {
    description = "powerline-shell rewritten in Rust, inspired by powerline-go";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
