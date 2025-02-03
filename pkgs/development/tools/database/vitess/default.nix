{ lib, buildGoModule, fetchFromGitHub, sqlite }:

buildGoModule rec {
  pname = "vitess";
  version = "20.0.2";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I+pz8bz/H1mg7cQnPiJZxYr1gyzajMLVqg8yHbBXYLc=";
  };

  vendorHash = "sha256-ZDPDL7vJoPv5pIS5xhHAgLiZsiF2B85KNnqGQJPk1SQ=";

  buildInputs = [ sqlite ];

  subPackages = [ "go/cmd/..." ];

  # integration tests require access to syslog and root
  doCheck = false;

  meta = with lib; {
    homepage = "https://vitess.io/";
    changelog = "https://github.com/vitessio/vitess/releases/tag/v${version}";
    description = "Database clustering system for horizontal scaling of MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
