{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, stdenv
, Security
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "coldsnap";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M3TzzaOTbe0VbAd2HSUC/S5Sfuanv8Ad17C6vBNb2og=";
  };
  cargoHash = "sha256-N6066QMGA2XAQ7xr6d34Ts7lVcnRC0uFo0/xpPceNcQ=";

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "A command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.apsl20;
    maintainers = teams.determinatesystems.members;
  };
}
