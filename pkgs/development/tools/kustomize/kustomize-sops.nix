{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kustomize-sops";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "viaduct-ai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FSRjPXS4Dk5oH8EO7TW6iHdGNvVhaQ7gZJ+qROXUU3U=";
  };

  vendorHash = "sha256-1qnNJltam04uLMhH8YftAl2jjEZP2UhVIMp9Vcy3jeg=";

  installPhase = ''
    mkdir -p $out/lib/viaduct.ai/v1/ksops-exec/
    mv $GOPATH/bin/kustomize-sops $out/lib/viaduct.ai/v1/ksops-exec/ksops-exec
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
