{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, SystemConfiguration, CoreFoundation, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    sha256 = "0jz0gddw1xp51rnap0dsyq4886x2glmr087r1lf3fxlnv6anaqn9";
  };

  cargoSha256 = "046blw366d6zjpq944g9n4cdhhv2w97qfi1ynljc9bnz03d8v39c";

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
