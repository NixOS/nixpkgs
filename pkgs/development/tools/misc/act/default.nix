{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "act";
  version = "0.2.63";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-umYP/U1UjqWbF1YDZYbQrlMubhxr80FFBDS1NeiI9wI=";
  };

  vendorHash = "sha256-Dt6V1zngSra4ZMSboHzreqwxgH5ovMIB+Bq3eWK6tjA=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kashw2 ];
  };
}
