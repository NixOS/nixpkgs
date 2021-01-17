{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "matrix-corporal";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "devture";
    repo = pname;
    rev = version;
    sha256 = "1n8yjmy3j0spgwpxgc26adhpl52fm3d2xbmkf5n9dwzw29grv68r";
  };

  buildFlagsArray = [
    "-ldflags=-s -w -X main.GitCommit=${version} -X main.GitBranch=${version} -X main.GitState=nixpkgs -X main.GitSummary=${version} -X main.Version=${version}"
  ];

  vendorSha256 = "1gi6mff6h0fkgfq5yybd1qcy2qwrvc4kzi11x7arfl9nr0d24rb2";

  meta = with lib; {
    homepage = "https://github.com/devture/matrix-corporal";
    description = "Reconciliator and gateway for a managed Matrix server";
    maintainers = with maintainers; [ dandellion ];
    license = licenses.agpl3Only;
  };
}
