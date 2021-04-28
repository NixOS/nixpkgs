{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.10.7";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "08k5j469750bhlq49qc5nwc2jjgmy9qsm58nf2jfwhxlpflv12sc";
  };

  cargoSha256 = "1r8w5cdygd26m95q9qpqa85aixx25jr510hpjlllbpfvm7zjpbqk";

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
