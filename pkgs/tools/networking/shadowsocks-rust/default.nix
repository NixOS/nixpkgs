{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.9.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "1lxx9xzkv3y2qjffa5dmwv0ygka71dx3c2995ggcgy5fb19yrghc";
  };

  cargoSha256 = "0p93dv4nlwl5167dmp160l09wqba5d40gaiwc6vbzb4iqdicgwls";

  RUSTC_BOOTSTRAP = 1;

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  checkFlags = [ "--skip=http_proxy" "--skip=udp_tunnel" ];

  meta = with lib; {
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    description = "A Rust port of shadowsocks";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
