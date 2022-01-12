{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "konstraint";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "plexsystems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vt8/hYsThBoAxMglF8pjdVphmkbHXsuzaHFJhnGXdU4=";
  };
  vendorSha256 = "sha256-3m+mN90Edb/yMgVmkokRQrDM2EdB7cb2opL0QZJ8L+U=";

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
