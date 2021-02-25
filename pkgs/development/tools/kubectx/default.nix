{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubectx";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "11c31nzz39nwzsaphv2j9gv9cjls6z11fc5nchwfm83sf54khv3b";
  };

  vendorSha256 = "1j662bbhjc8wz7awc0d2mamlq0rihhnizp3xb3gw0fh15nl1mi72";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completion/*
  '';

  meta = with lib; {
    description = "Fast way to switch between clusters and namespaces in kubectl!";
    license = licenses.asl20;
    homepage = "https://github.com/ahmetb/kubectx";
    maintainers = with maintainers; [ jlesquembre Chili-Man ];
    platforms = with platforms; unix;
  };
}
