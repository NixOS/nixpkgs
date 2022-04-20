{ lib
, fetchFromGitHub
, buildGoModule
, stayrtr
, testers
}:

buildGoModule rec {
  pname = "stayrtr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "stayrtr";
    rev = "v${version}";
    sha256 = "10ndb8p7znnjycwg56m63gzqf9zc6lq9mcvz4n48j0c4il5xyn8x";
  };
  vendorSha256 = "1nwrzbpqycr4ixk8a90pgaxcwakv5nlfnql6hmcc518qrva198wp";

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
