{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-eco";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "coloradocolby";
    repo = "gh-eco";
    rev = "v${version}";
    sha256 = "sha256-P/s7uSD5MWwiw0ScRVHAlu68GflrGxgPNpVAMdpxYcs=";
  };

  vendorSha256 = "sha256-Qx/QGIurjKGFcIdCot1MFPatbGHfum48JOoHlvqA64c=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/coloradocolby/gh-eco";
    description = "gh extension to explore the ecosystem";
    license = licenses.mit;
    maintainers = with maintainers; [ helium ];
  };
}

