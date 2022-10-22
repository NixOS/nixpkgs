{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, pcsclite
, nettle
, PCSC
, testers
, openpgp-card-tools
}:

rustPlatform.buildRustPackage rec {
  pname = "openpgp-card-tools";
  version = "0.0.12";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3OKOMe7Uj+8qpzfu0DzqwIGa/QJ0YoKczPN9W8HXJZU=";
  };

  cargoHash = "sha256-gq17BXorXrlJx4zlvLuOT8XGUCqZXFDSxgs/Fv9dChk=";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "opgpcard";
  };
}
