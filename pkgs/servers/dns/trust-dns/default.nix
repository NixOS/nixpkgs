{ lib
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "trust-dns";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "v${version}";
    hash = "sha256-w87WpuFKSOdObNiqET/pp2sJql1q0+xyns8+nMPj0xE=";
  };
  cargoHash = "sha256-sLhhwSsyzdxq7V9rpD42cu76T1mt4uCOx2NAmIf5sF8=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # tests expect internet connectivity to query real nameservers like 8.8.8.8
  doCheck = false;

  meta = with lib; {
    description = "A Rust based DNS client, server, and resolver";
    homepage = "https://trust-dns.org/";
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
    license = with licenses; [ asl20 mit ];
    mainProgram = "hickory-dns";
  };
}
