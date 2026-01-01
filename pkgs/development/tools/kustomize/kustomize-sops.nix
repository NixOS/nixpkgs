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
<<<<<<< HEAD
    ln -s $out/bin/ksops $out/lib/viaduct.ai/v1/ksops/ksops
=======
    ln -s $ous/bin/ksops $out/lib/viaduct.ai/v1/ksops/ksops
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  # Tests are broken in a nix environment
  doCheck = false;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Flexible Kustomize Plugin for SOPS Encrypted Resource";
    longDescription = ''
      KSOPS can be used to decrypt any Kubernetes resource, but is most commonly
      used to decrypt encrypted Kubernetes Secrets and ConfigMaps.
    '';
    homepage = "https://github.com/viaduct-ai/kustomize-sops";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ starcraft66 ];
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ starcraft66 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
