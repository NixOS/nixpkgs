{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, sqlcmd
, testers
}:

buildGoModule rec {
  pname = "sqlcmd";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "0.15.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = "go-sqlcmd";
    owner = "microsoft";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-omclEa/URexzzpn5jRw2ivBPxmx6kw+WBIOk4XZASkU=";
  };

  vendorHash = "sha256-mqyKH6xLfTqKVStEZYqau19U9y/NlqoD0XLeoWHScgM=";
=======
    sha256 = "sha256-6ofLXGrwkPBXQC+wb3sNqeMsVin5kBD8GyM7Ywu7xDs=";
  };

  vendorHash = "sha256-6JfxKzYAjSQ9JFuFGDUZ0ALS1D7f2LK3bP0Fbl2ivo0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
