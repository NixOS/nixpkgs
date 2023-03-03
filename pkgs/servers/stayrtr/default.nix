{ lib
, fetchFromGitHub
, buildGoModule
, stayrtr
, testers
}:

buildGoModule rec {
  pname = "stayrtr";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "stayrtr";
    rev = "v${version}";
    sha256 = "sha256-5M4KbP5bmG+jUjR8hXJ2yyLLuLXzBvVGfjANv/Zb3jc=";
  };
  vendorHash = "sha256-oOFJNaj4wpfX7ct11W519V9dJh0/zGpuLImepLT17Eg=";

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
