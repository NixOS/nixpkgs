{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    sha256 = "sha256-pQlrKjhOJfjNEmLxqnFmmBY1naheZUsaq2tGdLKGxjg=";
  };

  patches = [
    # https://github.com/launchbadge/sqlx/pull/2228
    (fetchpatch {
      name = "fix-rust-1.65-compile.patch";
      url = "https://github.com/launchbadge/sqlx/commit/2fdf85b212332647dc4ac47e087df946151feedf.patch";
      hash = "sha256-5BCuIwmECe9qQrdYll7T+UOGwuTBolWEhKNE7GcZqJw=";
    })
  ];

  cargoSha256 = "sha256-AbA8L7rkyZfKW0vvjyrcW5eU6jGD+zAqIcEUOJmeqJs=";

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
    maintainers = with maintainers; [ greizgh ];
  };
}
