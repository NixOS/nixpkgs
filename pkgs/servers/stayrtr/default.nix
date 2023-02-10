{ lib
, fetchFromGitHub
, buildGoModule
, stayrtr
, testers
}:

buildGoModule rec {
  pname = "stayrtr";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "stayrtr";
    rev = "v${version}";
    sha256 = "sha256-oRFBvue5Tcgty1GgsZGb/CMHmKM0mIc5vWOMsL/0IfI=";
  };
  vendorHash = "sha256-VomrmyNa5I6AVSpw5sg0e4b7w/JlFQINBYm+eh1FoNw=";

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
