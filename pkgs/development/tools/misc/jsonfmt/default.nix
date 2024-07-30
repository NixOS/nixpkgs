{ lib
, buildGoModule
, fetchFromGitHub
, testers
, jsonfmt
}:

buildGoModule rec {
  pname = "jsonfmt";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "jsonfmt";
    rev = "v${version}";
    hash = "sha256-rVv7Dv4vQmss4eiiy+KaO9tZ5U58WlRlsOz4QO0gdfM=";
  };

  vendorHash = "sha256-xtwN+TemiiyXOxZ2DNys4G6w4KA3BjLSWAmzox+boMY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = jsonfmt;
    };
  };

  meta = with lib; {
    description = "Formatter for JSON files";
    homepage = "https://github.com/caarlos0/jsonfmt";
    changelog = "https://github.com/caarlos0/jsonfmt/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "jsonfmt";
  };
}
