{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gopls";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    hash = "sha256-4RpQrlFj0stefVBouxyYN3Pf0PkYZ4cn4IKIskqUhVY=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-D+ew0XyHRns1i9KAdV5vhCs3Uu338EujYjwU6IIZ8OY=";

  # https://github.com/golang/tools/blob/9ed98faa/gopls/main.go#L27-L30
  ldflags = [ "-X main.version=v${version}" ];

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    changelog = "https://github.com/golang/tools/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      mic92
      rski
      SuperSandro2000
      zimbatm
    ];
    mainProgram = "gopls";
  };
}
