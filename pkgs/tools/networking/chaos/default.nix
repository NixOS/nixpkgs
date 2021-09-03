{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "chaos";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "chaos-client";
    rev = "v${version}";
    sha256 = "13lblrckf65y7kd3lw4s12bi05rv4iv25sr5xbp63l9ly5sbzaz6";
  };

  vendorSha256 = "1mc60jkf7xmf3zsb2fihsgg3jkb2mfvsw84aby2kqcf14hdsk2gl";

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
