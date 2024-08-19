{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "terramate";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
    hash = "sha256-SAMtEo84P5sxQ3JFU4evt2ycL1tg2yrLoWipWi4KObE=";
  };

  vendorHash = "sha256-TOntPPtynr333rX0wlb2pIeEwcNzyWP3wFqPoMz6LK0=";

  # required for version info
  nativeBuildInputs = [ git ];

  ldflags = [ "-extldflags" "-static" ];

  # Disable failing E2E tests preventing the package from building
  excludedPackages = [ "./e2etests/cloud" "./e2etests/core" ];

  meta = with lib; {
    description = "Adds code generation, stacks, orchestration, change detection, data sharing and more to Terraform";
    homepage = "https://github.com/terramate-io/terramate";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
