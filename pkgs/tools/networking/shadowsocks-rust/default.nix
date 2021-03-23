{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.9.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "1mqxfw21ilcy0gc2jrn5f385y3g9inabp9fjc39m5ydljja4g5b9";
  };

  cargoSha256 = "1ja2hcsa2wa0zmblz4ps35jcx1y29j469lf4i9a7sw0kgh3xp1ha";

  RUSTC_BOOTSTRAP = 1;

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  checkFlags = [ "--skip=http_proxy" "--skip=udp_tunnel" ];

  meta = with lib; {
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    description = "A Rust port of shadowsocks";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    broken = stdenv.isAarch64;  # crypto2 crate doesn't build on aarch64
  };
}
