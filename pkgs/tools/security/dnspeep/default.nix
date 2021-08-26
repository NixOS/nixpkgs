{ fetchFromGitHub, lib, libpcap, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dnspeep";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jvns";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lz22vlgi1alsq676q4nlzfzwnsrvziyqdnmdbn00rwqsvlb81q6";
  };

  # dnspeep has git dependencies therefore doesn't work with `cargoSha256`
  cargoLock = {
    # update Cargo.lock every update
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pcap-0.8.1" = "1nnfyhlhcpbl4i6zmfa9rvnvr6ibg5khran1f5yhmr9yfhmhgakd";
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
