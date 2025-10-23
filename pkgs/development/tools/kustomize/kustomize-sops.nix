{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kustomize-sops";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "viaduct-ai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-a9SvkHt8ZQFobOjKAECSJcRZEeRE8pTKLnXN4DYNa7k=";
  };

  vendorHash = "sha256-ajXW6H1XBgVtMdK7/asfpy6e3rFAD2pz3Lg+QFnkVpo=";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/viaduct.ai/v1/ksops/
    mkdir -p $out/lib/viaduct.ai/v1/ksops-exec/
    mv $GOPATH/bin/kustomize-sops $out/bin/ksops
    ln -s $out/bin/ksops $out/lib/viaduct.ai/v1/ksops-exec/ksops-exec
    ln -s $ous/bin/ksops $out/lib/viaduct.ai/v1/ksops/ksops
  '';

  # Tests are broken in a nix environment
  doCheck = false;

  meta = with lib; {
    description = "Flexible Kustomize Plugin for SOPS Encrypted Resource";
    longDescription = ''
      KSOPS can be used to decrypt any Kubernetes resource, but is most commonly
      used to decrypt encrypted Kubernetes Secrets and ConfigMaps.
    '';
    homepage = "https://github.com/viaduct-ai/kustomize-sops";
    license = licenses.asl20;
    maintainers = with maintainers; [ starcraft66 ];
  };
}
