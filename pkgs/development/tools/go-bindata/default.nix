{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-bindata";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "kevinburke";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3/1RqJrv1fsPKsZpurp2dHsMg8FJBcFlI/pwwCf5H6E=";
  };

  vendorHash = null;

  subPackages = [ "go-bindata" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/kevinburke/go-bindata";
    changelog = "https://github.com/kevinburke/go-bindata/blob/v${version}/CHANGELOG.md";
    description = "A small utility which generates Go code from any file, useful for embedding binary data in a Go program";
    mainProgram = "go-bindata";
    maintainers = with maintainers; [ ];
    license = licenses.cc0;
  };
}
