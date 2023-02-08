{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kustomize-sops";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "viaduct-ai";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8CZcPZLainc7iRZ5Ul27QxW3oK7sikCjzCBEkfCeNUc=";
  };

  vendorHash = "sha256-GBjMN6pyB+48e5LNqLBbh6a5fC9P0T53CZUPGNcbBDc=";

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
