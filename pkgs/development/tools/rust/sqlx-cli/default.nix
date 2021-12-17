{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, SystemConfiguration, CoreFoundation, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    sha256 = "sha256-z8gIuMknqiXpmXANS+V1GYioevCysDDzb+UYc9NeU04=";
  };

  cargoSha256 = "sha256-b+X4u83Jae2xjKFT4lYqSk125wPQjMiM8wZ36tA/rjo=";

  doCheck = false;
  cargoBuildFlags = [ "-p sqlx-cli" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration CoreFoundation Security libiconv ];

  meta = with lib; {
    description =
      "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh ];
  };
}
