{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "chaos";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "chaos-client";
    rev = "v${version}";
    sha256 = "sha256-uND88KGlUxGH3lGlcNdjSRsti/7FofruFJIcftdgzcE=";
  };

  vendorSha256 = "sha256-pzh/t8GeJXLIydSGoQ3vOzZ6xdHov6kdYgu2lKh/BNo=";

  subPackages = [
    "cmd/chaos/"
  ];

  meta = with lib; {
    description = "Tool to communicate with Chaos DNS API";
    homepage = "https://github.com/projectdiscovery/chaos-client";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
