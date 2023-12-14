{ lib
, buildGoModule
, fetchFromGitHub
, makeBinaryWrapper
}:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yTCeltueOxGkOin6Cq6RzY7YNmHMz64wza8e0Pwr36E=";
  };

  vendorHash = "sha256-BnfWivu7xRmgDQgPIkjF48dOpU7hkw+Qkvb11eASDEk=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${version}"
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/cloud-nuke --set-default DISABLE_TELEMETRY true
  '';

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    changelog = "https://github.com/gruntwork-io/cloud-nuke/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
