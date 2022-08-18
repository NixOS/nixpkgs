{ lib
, fetchFromGitHub
, pkgs
, stdenv
, rustPlatform
, pkg-config
, cmake
, openssl
, autoconf
, automake
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hebbot";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "haecker-felix";
    repo = "hebbot";
    rev = "v${version}";
    sha256 = "sha256-zcsoTWpNonkgJLTC8S9Nubnzdhj5ROL/UGNWUsLxLgs=";
  };

  cargoSha256 = "sha256-ZNETA2JUZCS8/a2oeF+JCGVKbzeyhp51D0BmBTPToOw=";

  nativeBuildInputs = [ pkg-config cmake ] ++
    lib.optionals stdenv.isDarwin [ autoconf automake ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A Matrix bot which can generate \"This Week in X\" like blog posts ";
    homepage = "https://github.com/haecker-felix/hebbot";
    changelog = "https://github.com/haecker-felix/hebbot/releases/tag/v${version}";
    license = with licenses; [ agpl3 ];
    maintainers = with maintainers; [ a-kenji ];
  };
}
