{ lib, rustPlatform, fetchFromGitHub, libpcap }:

rustPlatform.buildRustPackage rec {
  pname = "dnspeep";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jvns";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lz22vlgi1alsq676q4nlzfzwnsrvziyqdnmdbn00rwqsvlb81q6";
  };

  cargoSha256 = "sha256-I1m+6M2tmmTZuXlZaecSslj6q2iCsMBq7k9vHiMd3WE=";

  LIBPCAP_LIBDIR = lib.makeLibraryPath [ libpcap ];
  LIBPCAP_VER = libpcap.version;

  meta = with lib; {
    description = "Spy on the DNS queries your computer is making";
    homepage = "https://github.com/jvns/dnspeep";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
