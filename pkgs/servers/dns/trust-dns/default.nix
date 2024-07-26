{ lib
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "trust-dns";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "v${version}";
    hash = "sha256-szq21RuRmkhAfHlzhGQYpwjiIRkavFCPETOt+6TxhP4=";
  };
  cargoHash = "sha256-zGn5vHwsHgpkgOr30QiyScqnfXjH55LQIVtxoUUox64=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # tests expect internet connectivity to query real nameservers like 8.8.8.8
  doCheck = false;

  meta = with lib; {
    description = "Rust based DNS client, server, and resolver";
    homepage = "https://trust-dns.org/";
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
    license = with licenses; [ asl20 mit ];
    mainProgram = "hickory-dns";
  };
}
