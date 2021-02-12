{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    sha256 = "1q6p4qly9qjn333nj72sar6nbyclfdw9i9l6rnimswylj0rr9n27";
  };

  cargoSha256 = "1jqx6fy7qyzk9r5h2fnbxgmymvpwrnpb34i25psfv71nidvvv07z";

  doCheck = false;
  cargoBuildFlags = [ "-p sqlx-cli" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description =
      "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh ];
  };
}
