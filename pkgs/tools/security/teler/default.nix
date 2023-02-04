{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "teler";
  version = "2.0.0-dev.3";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "teler";
    rev = "v${version}";
    hash = "sha256-2QrHxToHxHTjSl76q9A8fXCkOZkCwh1fu1h+HDUGsGA=";
  };

  vendorHash = "sha256-gV/PJFcANeYTYUJG3PYNsApYaeBLx76+vVBvcuKDYO4=";

  ldflags = [
    "-s"
    "-w"
    "-X ktbs.dev/teler/common.Version=${version}"
  ];

  # test require internet access
  doCheck = false;

  meta = with lib; {
    description = "Real-time HTTP Intrusion Detection";
    longDescription = ''
      teler is an real-time intrusion detection and threat alert
      based on web log that runs in a terminal with resources that
      we collect and provide by the community.
    '';
    homepage = "https://github.com/kitabisa/teler";
    changelog = "https://github.com/kitabisa/teler/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
