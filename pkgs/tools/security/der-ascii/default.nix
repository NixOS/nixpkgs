{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "der-ascii";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1my93m1rx08kn2yms6k8w43byr8k61r1nra4b082j8b393wwxkqc";
  };
  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = ''
      A small human-editable language to emit DER or BER encodings of ASN.1
      structures and malformed variants of them
    '';
    homepage = "https://github.com/google/der-ascii";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexshpilkin cpu hawkw ];
    mainProgram = "ascii2der"; # has stable output, unlike its inverse
  };
}
