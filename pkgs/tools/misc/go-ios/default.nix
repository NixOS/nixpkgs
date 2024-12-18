{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "go-ios";
  version = "1.0.121";

  src = fetchFromGitHub {
    owner = "danielpaulus";
    repo = "go-ios";
    rev = "v${version}";
    sha256 = "sha256-zWaEtfxrJYaROQ05nBQvM5fiIRSG+hCecU+BVnpIuck=";
  };

  vendorHash = "sha256-0Wi9FCTaOD+kzO5cRjpqbXHqx5UAKSGu+hc9bpj+PWo=";

  excludedPackages = [
    "restapi"
  ];

  checkFlags = [
    "-tags=fast"
  ];

  postInstall = ''
    # aligns the binary with what is expected from go-ios
    mv $out/bin/go-ios $out/bin/ios
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Operating system independent implementation of iOS device features";
    homepage = "https://github.com/danielpaulus/go-ios";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
    mainProgram = "ios";
  };
}
