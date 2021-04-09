{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.10.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "1ds2270pw187hbg01lcqxw0631m0ypvbza47z5ndgn6dxprga9wk";
  };

  cargoSha256 = "0aarhv78ab3z893cgiixxjpxl6xcwi96saavnzw4zd68988lb24r";

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
