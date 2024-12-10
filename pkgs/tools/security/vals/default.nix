{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vals,
}:

buildGoModule rec {
  pname = "vals";
  version = "0.37.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "helmfile";
    repo = pname;
    sha256 = "sha256-POFxoGUbcasEvFdovZ1RER+yxLzg9owyKjWcr1zI+nc=";
  };

  vendorHash = "sha256-Yzab4Y6ETOZM5zL/5fQSzqNFi51YOgDjsL53efW1vvk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Tests require connectivity to various backends.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = vals;
    command = "vals version";
  };

  meta = with lib; {
    description = "Helm-like configuration values loader with support for various sources";
    mainProgram = "vals";
    license = licenses.asl20;
    homepage = "https://github.com/helmfile/vals";
    changelog = "https://github.com/helmfile/vals/releases/v${version}";
    maintainers = with maintainers; [ stehessel ];
  };
}
