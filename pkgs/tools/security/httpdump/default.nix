{ buildGoModule
, fetchFromGitHub
, lib
, libpcap
}:

buildGoModule rec {
  pname = "httpdump";
<<<<<<< HEAD
  version = "unstable-2023-05-07";
=======
  version = "20210126-${lib.strings.substring 0 7 rev}";
  rev = "d2e0deadca5f9ec2544cb252da3c450966d1860e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hsiafan";
    repo = pname;
<<<<<<< HEAD
    rev = "e971e00e0136d5c770c4fdddb1c2095327d419d8";
    hash = "sha256-3BzvIaZKBr/HHplJe5hM7u8kigmMHxCvkiVXFZopUCQ=";
  };

  vendorHash = "sha256-NKCAzx1+BkqZGeAORl7gCA7f9PSsyKxP2eggZyBB2l8=";

  propagatedBuildInputs = [ libpcap ];

  ldflags = [ "-s" "-w" ];

=======
    inherit rev;
    sha256 = "0yh8kxy1k23lln09b614limwk9y59r7cn5qhbnzc06ga4mxfczv2";
  };

  vendorSha256 = null; #vendorSha256 = "";

  propagatedBuildInputs = [ libpcap ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Parse and display HTTP traffic from network device or pcap file";
    homepage = "https://github.com/hsiafan/httpdump";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
<<<<<<< HEAD
=======
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.go-modules --check
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
