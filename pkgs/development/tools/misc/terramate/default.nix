{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "terramate";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
    hash = "sha256-jcmOS81iPzy1ul0Cj/SiJk84AUIq7mLI+CmspuPit+o=";
  };

  vendorHash = "sha256-Na2XDPSwgwWTQrweslAtSOh2+B/ZFaPIdy8ssAFWkGs=";

  # required for version info
  nativeBuildInputs = [ git ];

  ldflags = [
    "-extldflags"
    "-static"
  ];

  # Disable failing E2E tests preventing the package from building
  excludedPackages = [
    "./cmd/terramate/e2etests/cloud"
    "./cmd/terramate/e2etests/core"
  ];

  meta = with lib; {
    description = "Adds code generation, stacks, orchestration, change detection, data sharing and more to Terraform";
    homepage = "https://github.com/terramate-io/terramate";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
