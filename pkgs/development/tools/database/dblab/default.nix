{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dblab";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${version}";
    hash = "sha256-p579rxv8ntNLfunKl6JGYE7eFZc51p2OGWGhQmAuADY=";
  };

  vendorHash = "sha256-RmZkSlA6KU1wXKFHPLYVhRjwxsDjO1XNoGBdNCmeGSw=";

  ldflags = [ "-s -w -X main.version=${version}" ];

  # some tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Database client every command line junkie deserves";
    homepage = "https://github.com/danvergara/dblab";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
