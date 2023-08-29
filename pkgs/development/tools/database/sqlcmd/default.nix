{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, sqlcmd
, testers
}:

buildGoModule rec {
  pname = "sqlcmd";
  version = "1.3.0";

  src = fetchFromGitHub {
    repo = "go-sqlcmd";
    owner = "microsoft";
    rev = "v${version}";
    sha256 = "sha256-omclEa/URexzzpn5jRw2ivBPxmx6kw+WBIOk4XZASkU=";
  };

  vendorHash = "sha256-mqyKH6xLfTqKVStEZYqau19U9y/NlqoD0XLeoWHScgM=";
  proxyVendor = true;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  subPackages = [ "cmd/modern" ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    mv $out/bin/modern $out/bin/sqlcmd

    installShellCompletion --cmd sqlcmd \
      --bash <($out/bin/sqlcmd completion bash) \
      --fish <($out/bin/sqlcmd completion fish) \
      --zsh <($out/bin/sqlcmd completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = sqlcmd;
    command = "sqlcmd --version";
    inherit version;
  };

  meta = {
    description = "A command line tool for working with Microsoft SQL Server, Azure SQL Database, and Azure Synapse";
    homepage = "https://github.com/microsoft/go-sqlcmd";
    changelog = "https://github.com/microsoft/go-sqlcmd/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ratsclub ];
  };
}
