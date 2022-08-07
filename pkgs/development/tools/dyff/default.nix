{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "dyff";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "dyff";
    rev = "v${version}";
    sha256 = "sha256-6r7e35hJrrkBaDHMUJGVOP7b0OwekJzedTs/P5E8Ykc=";
  };

  vendorSha256 = "sha256-nam/so7ylbGVhEjGKZzeYZyHz90rq5XEZelHkjcIeh8=";

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
