{ buildGoModule
, fetchFromGitHub
, lib
, libpcap
}:

buildGoModule rec {
  pname = "httpdump";
  version = "20210126-${lib.strings.substring 0 7 rev}";
  rev = "d2e0deadca5f9ec2544cb252da3c450966d1860e";

  src = fetchFromGitHub {
    owner = "hsiafan";
    repo = pname;
    inherit rev;
    sha256 = "0yh8kxy1k23lln09b614limwk9y59r7cn5qhbnzc06ga4mxfczv2";
  };

  vendorSha256 = null; #vendorSha256 = "";

  propagatedBuildInputs = [ libpcap ];

  meta = with lib; {
    description = "Parse and display HTTP traffic from network device or pcap file";
    homepage = "https://github.com/hsiafan/httpdump";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.go-modules --check
  };
}
