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
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Wgj6YZSQj8+BcyPboUTadUOg6Gq6VxV4GRW8TWbnRfc=";
  };

  cargoHash = "sha256-u6xzKDCtv5FzaYgn5wab6ZPICJ/DaqUxiRS80xaEa1A=";

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
