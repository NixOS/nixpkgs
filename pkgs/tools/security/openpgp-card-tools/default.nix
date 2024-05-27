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
  version = "0.10.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${version}";
    hash = "sha256-fasu2XElGk6TB2VNFg43rpa3ZafgGZga9WojyUiXj0k=";
  };

  cargoHash = "sha256-7OauQRG8DhIoANfel45QBm3igGjmtNw9KNAwt1TL5xg=";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ pcsclite nettle ] ++ lib.optionals stdenv.isDarwin [ PCSC ];

  passthru = {
    tests.version = testers.testVersion {
      package = openpgp-card-tools;
    };
  };

  meta = with lib; {
    description = "A tool for inspecting and configuring OpenPGP cards";
    homepage = "https://codeberg.org/openpgp-card/openpgp-card-tools";
    license = with licenses ;[ asl20 /* OR */ mit ];
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "oct";
  };
}
