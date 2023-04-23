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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pcap-0.8.1" = "sha256-baoHK3Q+5Qp9ccGqDGd5K5q87c5JufpNJHRdBin0zto=";
    };
  };

  LIBPCAP_LIBDIR = lib.makeLibraryPath [ libpcap ];
  LIBPCAP_VER = libpcap.version;

  meta = with lib; {
    description = "Spy on the DNS queries your computer is making";
    homepage = "https://github.com/jvns/dnspeep";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
