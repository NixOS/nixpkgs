{ lib
, stdenv
, rustPlatform
, fetchFromGitea
, pkg-config
, pcsclite
, nettle
, PCSC
, testers
, openpgp-card-tools
}:

rustPlatform.buildRustPackage rec {
  pname = "openpgp-card-tools";
  version = "0.9.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${version}";
    hash = "sha256-VD0eDq+lfeAu2gY9VZfz2ola3+CJCWerTEaGivpILyo=";
  };

  cargoHash = "sha256-tfawWfwsdWUOimd97b059HXt83ew6KBouI2MdGN8Knc=";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ pcsclite nettle ] ++ lib.optionals stdenv.isDarwin [ PCSC ];

  passthru = {
    tests.version = testers.testVersion {
      package = openpgp-card-tools;
    };
  };

  meta = with lib; {
    description = "CLI tools for OpenPGP cards";
    homepage = "https://gitlab.com/openpgp-card/openpgp-card";
    license = with licenses ;[ asl20 /* OR */ mit ];
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "opgpcard";
  };
}
