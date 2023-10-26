{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize-sops";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "viaduct-ai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dtfs2hUC1Y0N5R/qYrW/bQ+w1X95rgNjo3e9FBKnkvg=";
  };

  vendorHash = "sha256-iBzW/IdG8NTlw22If6PwGsoikB2l3hIvTf7lLQa4s4c=";

  installPhase = ''
    mkdir -p $out/lib/viaduct.ai/v1/ksops-exec/
    mv $GOPATH/bin/kustomize-sops $out/lib/viaduct.ai/v1/ksops-exec/ksops-exec
  '';

  # Tests are broken in a nix environment
  doCheck = false;

  meta = with lib; {
    description = "A Flexible Kustomize Plugin for SOPS Encrypted Resource";
    longDescription = ''
      KSOPS can be used to decrypt any Kubernetes resource, but is most commonly
      used to decrypt encrypted Kubernetes Secrets and ConfigMaps.
    '';
    homepage = "https://github.com/viaduct-ai/kustomize-sops";
    license = licenses.asl20;
    maintainers = with maintainers; [ starcraft66 ];
  };
}
