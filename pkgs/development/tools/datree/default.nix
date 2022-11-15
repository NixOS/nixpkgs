{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "datree";
  version = "1.6.42";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = version;
    hash = "sha256-4sj+zyFYtG/C6oDuQno/rkyxgdnnvAn9GZ5qvqA+UhA=";
  };

  vendorSha256 = "sha256-gjD24nyQ8U1WwhUbq8N4dvzFK74t3as7wWZK7rh9yiw=";

  ldflags = [
    "-extldflags '-static'"
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/datree version | grep ${version} > /dev/null
  '';

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/datree completion $shell > datree.$shell
      installShellCompletion datree.$shell
    done
  '';

  doCheck = true;

  meta = with lib; {
    description =
      "CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies";
    homepage = "https://datree.io/";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.jceb ];
    mainProgram = "datree";
  };
}
