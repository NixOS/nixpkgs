{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    hash = "sha256-GJ2zc5OgZXwEq12f0PyvgOOUd7cctUbFvdp095VQb9E=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-Xxik0t1BHQPqzrE3Oh3VhODn+IqIVa+TCNqQSnmbBM0=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    changelog = "https://github.com/golang/tools/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
    mainProgram = "gopls";
  };
}
