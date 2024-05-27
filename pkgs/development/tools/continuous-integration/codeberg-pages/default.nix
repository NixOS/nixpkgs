{ lib, fetchFromGitea, buildGoModule }:

buildGoModule rec {
  pname = "codeberg-pages";
  version = "5.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Codeberg";
    repo = "pages-server";
    rev = "ea68a82cd22a8a8c1f265260af22b9406f13e3a9";
    hash = "sha256-TSXRB0oq1CtHC9ooO+Y3ICS5YE+q+ivZAcYBSd1oWi0=";
  };

  vendorHash = "sha256-vTYB3ka34VooN2Wh/Rcj+2S1qAsA2a/VtXlILn1W7oU=";

  postPatch = ''
    # disable httptest
    rm server/handler/handler_test.go
  '';

  ldflags = [ "-s" "-w" ];

  tags = [ "sqlite" "sqlite_unlock_notify" "netgo" ];

  meta = with lib; {
    mainProgram = "codeberg-pages";
    maintainers = with maintainers; [ laurent-f1z1 ];
    license = licenses.eupl12;
    homepage = "https://codeberg.org/Codeberg/pages-server";
    description = "Static websites hosting from Gitea repositories";
  };
}
