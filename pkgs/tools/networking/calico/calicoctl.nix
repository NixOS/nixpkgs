{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "calicoctl";
  version = "3.19.1";

  src = fetchFromGitHub {
    owner = "projectcalico";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TuuYGDzr9iuMB/dwnCPVLVv/4cUsrhc6T3rhQdJvy3k=";
  };

  vendorSha256 = "sha256-jcFKdP+Q+SYMTY2c370xWXoNfS58lLD+wd7iJVgjaqc=";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X github.com/projectcalico/calicoctl/v3/calicoctl/commands.VERSION=v${version}")
  '';

  excludedPackages = "scripts";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/calicoctl --help
    runHook postInstallCheck
  '';

  # Tests generally seem fine, one is hanging though
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.projectcalico.org/";
    changelog = "https://docs.projectcalico.org/release-notes/";
    description = " Calico CLI tool";
    longDescription = ''
      The command line tool, calicoctl, makes it easy to manage Calico network
      and security policy, as well as other Calico configurations.

      The calicoctl command line interface provides a number of resource
      management commands to allow you to create, modify, delete, and view the
      different Calico resources. This section is a command line reference for
      calicoctl, organized based on the command hierarchy.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
