{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, SystemConfiguration
, CoreFoundation
, Security
, libiconv
, testers
, sqlx-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    hash = "sha256-f9DCavvqq/a+1wusKlc3jOjyFRVMIAHGCryZxV5qews=";
  };

  cargoHash = "sha256-9vbrehtfw6ctIF7uXZPvODx3kkxz+m9h2Uv+2t45I0w=";

  doCheck = false;
  cargoBuildFlags = [ "-p sqlx-cli" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration CoreFoundation Security libiconv ];

  passthru.tests.version = testers.testVersion {
    package = sqlx-cli;
    command = "sqlx --version";
  };

  meta = with lib; {
    description =
      "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh xrelkd ];
  };
}
