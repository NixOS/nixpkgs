{ lib, rustPlatform, fetchFromGitHub, libpcap }:

rustPlatform.buildRustPackage rec {
  pname = "dnspeep";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jvns";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QpUbHiMDQFRCTVyjrO9lfQQ62Z3qanv0j+8eEXjE3n4=";
  };

  cargoSha256 = "sha256-w81FewtyweuSNYNPNr2uxB0uB1JoN5t252CAG1pm4Z8=";

  LIBPCAP_LIBDIR = lib.makeLibraryPath [ libpcap ];
  LIBPCAP_VER = libpcap.version;

  meta = with lib; {
    description = "Spy on the DNS queries your computer is making";
    homepage = "https://github.com/jvns/dnspeep";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
