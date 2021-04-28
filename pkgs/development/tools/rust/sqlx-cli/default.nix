{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, SystemConfiguration, CoreFoundation, Security }:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    sha256 = "1q6p4qly9qjn333nj72sar6nbyclfdw9i9l6rnimswylj0rr9n27";
  };

  cargoSha256 = "1393mwx6iccnqrry4ia4prcnnjxhp4zjq1s3gzwzfyzsrqyad54g";

  doCheck = false;
  cargoBuildFlags = [ "-p sqlx-cli" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration CoreFoundation Security ];

  meta = with lib; {
    description =
      "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh ];
  };
}
