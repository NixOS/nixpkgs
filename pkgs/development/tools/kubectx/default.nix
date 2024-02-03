{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubectx";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WY0zFt76mvdzk/s2Rzqys8n+DVw6qg7V6Y8JncOUVCM=";
  };

  patches = [
    ./bump-golang-x-sys.patch
  ];

  vendorHash = "sha256-p4KUBmJw6hWG1J2qwg4QBbh6Vo1cr/HQz0IqytIDJjU=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion completion/*
  '';

  meta = with lib; {
    description = "Fast way to switch between clusters and namespaces in kubectl!";
    license = licenses.asl20;
    homepage = "https://github.com/ahmetb/kubectx";
    maintainers = with maintainers; [ jlesquembre ];
  };
}
