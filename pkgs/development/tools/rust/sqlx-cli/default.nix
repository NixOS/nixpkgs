{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, SystemConfiguration, CoreFoundation, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    sha256 = "1051vldajdbkcxvrw2cig201c4nm68cvvnr2yia9f2ysmr68x5rh";
  };

  cargoSha256 = "1ry893gjrwb670v80ff61yb00jvf49yp6194gqrjvnyarjc6bbb1";

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
