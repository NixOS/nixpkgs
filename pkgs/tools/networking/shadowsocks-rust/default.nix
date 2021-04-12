{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.10.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "0nagn7792qniczzv0912h89bn8rm8hyikdiw7cqwknx0hw8dwz1z";
  };

  cargoSha256 = "0arqc0wnvfkmk8xzsdc6fvd1adazrw950ld8xyh7r588pyphjmhn";

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
