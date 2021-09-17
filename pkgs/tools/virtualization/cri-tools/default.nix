{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "cri-tools";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+36lGLpNnTQnwwmXoVNPt3RMcnE46AdXOpghvhP0Bq0=";
  };

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild
    make binaries VERSION=${version}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install BINDIR=$out/bin

    for shell in bash fish zsh; do
      $out/bin/crictl completion $shell > crictl.$shell
      installShellCompletion crictl.$shell
    done
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = "https://github.com/kubernetes-sigs/cri-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
  };
}
