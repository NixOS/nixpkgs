{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dblab";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${version}";
    hash = "sha256-3Bmus2yVTwvy0CpoNE1mzVvocpBnRoI11Sf+x2JXhgM=";
  };

  vendorHash = "sha256-vf0CeiLBVqMGV2oqxRHzhvL7SoT9zcg8P5c63z3UR3g=";

  ldflags = [ "-s -w -X main.version=${version}" ];

  # some tests require network access
  doCheck = false;

  meta = with lib; {
    description = "The database client every command line junkie deserves";
    homepage = "https://github.com/danvergara/dblab";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
