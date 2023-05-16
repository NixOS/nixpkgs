{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ngLDKAwdrX385BIPYlQAYkA0Ty73wWwEesKQuC6+cvo=";
  };

  vendorHash = "sha256-NOQV7c930kutXmgi1eaETu1JMJerKNK2Ns4YBRaoBUw=";
=======
    sha256 = "sha256-sy5R2QSVkxFmfRMiD5KDzkFCol7MpOnfz0/JR++zIX4=";
  };

  vendorHash = "sha256-UY/8fWPoO3d0g1/CN215Q4z744S2cCT7fB4ctpridAI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-X main.version=${version}"
  ];

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  passthru.tests.version = testers.testVersion {
    package = clickhouse-backup;
  };

  meta = with lib; {
    description = "Tool for easy ClickHouse backup and restore with cloud storages support";
    homepage = "https://github.com/AlexAkulov/clickhouse-backup";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
