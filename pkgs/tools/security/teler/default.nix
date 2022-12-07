{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "teler";
  version = "2.0.0-dev.2";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "teler";
    rev = "v${version}";
    hash = "sha256-GlpQBmJ7HSKPFieM7E5NOnqGlUjQv9Ywe6XF5QIi+c4=";
  };

  vendorHash = "sha256-g2YBMyLDGQZKxDBcZ1mca16jxODnJzcmMfFivBn6SdE=";

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
