{ buildGoModule
, fetchFromGitHub
, lib
, sqlcmd
, testers
}:

buildGoModule rec {
  pname = "sqlcmd";
  version = "0.15.3";

  src = fetchFromGitHub {
    repo = "go-sqlcmd";
    owner = "microsoft";
    rev = "v${version}";
    sha256 = "sha256-1CdZVh7pbupCNOE1ydgYEqX4rYo2LRddlNRNf0QjlN0=";
  };

  vendorSha256 = "sha256-/51qs7ACE9UmyE59Tsto+Xm240H6IUL8eNKfLgb5LUE=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  subPackages = [
    "cmd/modern"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    mv $out/bin/modern $out/bin/sqlcmd
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = sqlcmd;
      command = "sqlcmd --version";
      inherit version;
    };
  };

  meta = with lib; {
    description = "A command line tool for working with Microsoft SQL Server, Azure SQL Database, and Azure Synapse";
    homepage = "https://github.com/microsoft/go-sqlcmd";
    changelog = "https://github.com/microsoft/go-sqlcmd/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ ratsclub ];
  };
}
