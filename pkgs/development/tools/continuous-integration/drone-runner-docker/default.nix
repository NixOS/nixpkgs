{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "drone-runner-docker";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "drone-runners";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3SbvnW+mCwaBCF77rAnDMqZRHX9wDCjXvFGq9w0E5Qw=";
  };

  vendorSha256 = "sha256-E18ykjQc1eoHpviYok+NiLaeH01UMQmigl9JDwtR+zo=";

  meta = with lib; {
    maintainers = with maintainers; [ endocrimes ];
    license = licenses.unfreeRedistributable;
    homepage = "https://github.com/drone-runners/drone-runner-docker";
    description = "Drone pipeline runner that executes builds inside Docker containers";
  };
}
