{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubectx";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-a2w4SXF6oOo4ZLYwF8I3mkqW9ktSbHiV/tym8b8Ng4U=";
  };

  vendorSha256 = "sha256-4sQaqC0BOsDfWH3cHy2EMQNMq6qiAcbV+RwxCdcSxsg=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completion/*
  '';

  meta = with lib; {
    description = "Fast way to switch between clusters and namespaces in kubectl!";
    license = licenses.asl20;
    homepage = "https://github.com/ahmetb/kubectx";
    maintainers = with maintainers; [ jlesquembre ];
    platforms = with platforms; unix;
  };
}
