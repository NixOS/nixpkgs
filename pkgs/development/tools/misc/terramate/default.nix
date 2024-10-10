{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "terramate";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
    hash = "sha256-CvvOJO57DotHpLB2FiAyYhF+WWXGuKEKCksnBWBiZ20=";
  };

  vendorHash = "sha256-kjzpXOoyTwjpYLBqDuB6Eup5Yzgej2U+HUo4z8V+cEI=";

  # required for version info
  nativeBuildInputs = [ git ];

  ldflags = [ "-extldflags" "-static" ];

  # Disable failing E2E tests preventing the package from building
  excludedPackages = [ "./e2etests/cloud" "./e2etests/core" ];

  meta = with lib; {
    description = "Adds code generation, stacks, orchestration, change detection, data sharing and more to Terraform";
    homepage = "https://github.com/terramate-io/terramate";
    changelog = "https://github.com/terramate-io/terramate/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya asininemonkey ];
  };
}
