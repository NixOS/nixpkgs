{ lib
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "trust-dns";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "bluejekyll";
    repo = "trust-dns";
    rev = "v${version}";
    sha256 = "sha256-b9tK1JbTwB3ZuRPh0wb3cOFj9dMW7URXIaFzUq0Yipw=";
  };
  cargoHash = "sha256-mpobdeTRWJzIEmhwtcM6UE66qRD5ot/0yLeQM6Tec+0=";

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
  };
}
