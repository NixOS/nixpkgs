{ lib, stdenv, rustPlatform, fetchFromGitHub, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "doh-server";
    rev = version;
    sha256 = "0jksdrji06ykk5cj6i8ydcjhagjwb2xz5bjs6qsw044p8a2hsq53";
  };

  cargoSha256 = "1wilm7bzr8h9yjwzw97ihavaylkv6nrk8f0vmm7kia69vqdrz9in";
  cargoPatches = [ ./cargo-lock.patch ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  doCheck = false; # no test suite, skip useless compile step

  meta = with lib; {
    homepage = "https://github.com/jedisct1/doh-server";
    description = "Fast, mature, secure DoH server proxy written in Rust";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ stephank ];
  };
}
