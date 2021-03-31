{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.10.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "155v63v0wf0ky5nl2f1dvky8n9pdk40l1lqyz8l1i1kjcvvcmj26";
  };

  cargoSha256 = "1vb6kis54g4lfc9d0h1961dclaqhq019iw509ydcsa1n7bp25caq";

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
