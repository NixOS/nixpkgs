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
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Mvnj8AEhREP+nGrioC9IHYX3k6sKGKzOh00V8nslyhw=";
  };

  cargoHash = "sha256-0KRq8GsrQaLJ6fopZpdzgxIWHIse9QWDo24IQj1eAhc=";

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
