{ lib
, fetchFromGitHub
, buildGoModule
, stayrtr
, testers
}:

buildGoModule rec {
  pname = "stayrtr";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "stayrtr";
    rev = "v${version}";
    hash = "sha256-/KwL/SEnHquFhPcYXpvQs71W4K1BrbqTPakatTNF47Q=";
  };
  vendorHash = "sha256-ndMME9m3kbv/c1iKlU2Pn/YoiRQy7jfVQri3M+qhujk=";

  patches = [
    ./go.mod.patch
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = stayrtr;
  };

  meta = with lib; {
    description = "Simple RPKI-To-Router server. (Hard fork of GoRTR)";
    homepage = "https://github.com/bgp/stayrtr/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
