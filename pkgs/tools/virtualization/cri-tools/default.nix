{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "cri-tools";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "06sxjhjpd893fn945c1s4adri2bf7s50ddvcw5pnwb6qndzfljw6";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    make binaries VERSION=${version}
  '';

  installPhase = ''
    make install BINDIR=$out/bin

    for shell in bash fish zsh; do
      $out/bin/crictl completion $shell > crictl.$shell
      installShellCompletion crictl.$shell
    done
  '';

  meta = with lib; {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = "https://github.com/kubernetes-sigs/cri-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
  };
}
