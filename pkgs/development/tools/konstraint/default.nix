{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "konstraint";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "plexsystems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j1rVkI5hXYtY0jtP+i/yRw1sS3iN3KyVI4gV9fNdj/E=";
  };
  vendorSha256 = "sha256-oYIUeHMEK55mCkf5cb5ECCU5y6tUZAM258sINrBl9kM=";

  # Exclude go within .github folder
  excludedPackages = ".github";

  ldflags = [ "-s" "-w" "-X github.com/plexsystems/konstraint/internal/commands.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/plexsystems/konstraint";
    changelog = "https://github.com/plexsystems/konstraint/releases/tag/v${version}";
    description = "A policy management tool for interacting with Gatekeeper";
    longDescription = ''
      konstraint is a CLI tool to assist with the creation and management of templates and constraints when using
      Gatekeeper. Automatically copy Rego to the ConstraintTemplate. Automatically update all ConstraintTemplates with
      library changes. Enable writing the same policies for Conftest and Gatekeeper.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
  };
}
