{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "dyff";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "dyff";
    rev = "v${version}";
    sha256 = "sha256-sEzS7pRjpCZNZSK1VVL628SNjIn9Di0eNOvvM/29WMM=";
  };

  vendorSha256 = "sha256-kanoe3cIvLROxqKZvdwFRnORv5I3eFLqOBZazvCnj48=";

  subPackages = [
    "cmd/dyff"
    "pkg/dyff"
    "internal/cmd"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # test fails with the injected version
  postPatch = ''
    substituteInPlace internal/cmd/cmds_test.go \
      --replace "version (development)" ${version}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/homeport/dyff/internal/cmd.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd dyff \
      --bash <($out/bin/dyff completion bash) \
      --fish <($out/bin/dyff completion fish) \
      --zsh <($out/bin/dyff completion zsh)
  '';

  meta = with lib; {
    description = "A diff tool for YAML files, and sometimes JSON";
    longDescription = ''
      dyff is inspired by the way the old BOSH v1 deployment output reported
      changes from one version to another by only showing the parts of a YAML
      file that change.

      Each difference is referenced by its location in the YAML document by
      using either the Spruce or go-patch path syntax.
    '';
    homepage = "https://github.com/homeport/dyff";
    license = licenses.mit;
    maintainers = with maintainers; [ edlimerkaj ];
  };
}
