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
  version = "0.9.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-F+j8bK0sBBLWlQzLAcvl6BdiI3Dy8ollwTpL7929nJ8=";
  };

  cargoHash = "sha256-Wn3fXAft+sju8FhX6YFHRvqt815NhTlfhLJarSemvm0=";

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
