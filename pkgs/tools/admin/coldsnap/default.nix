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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kL9u+IBlC9Pxm5yaJagY9dy0Pm0xlKfVxFVBmwDMSak=";
  };
  cargoHash = "sha256-eYBmke0FQ9CK3cCaM7ecmp1vkNlZO3SHRnxFzmelYhU=";

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
