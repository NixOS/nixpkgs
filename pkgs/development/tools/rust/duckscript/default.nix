{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  Security,
  openssl,
  pkg-config,
  SystemConfiguration,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "duckscript_cli";
  version = "0.11.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-afxzZkmmYnprUBquH681VHMDs3Co9C71chNoKbu6lEY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
      libiconv
    ];

  cargoHash = "sha256-TX/Xi57fn85GjHc74icxhsQ6n7FwqzGIr3Qoc2o681E=";

  meta = with lib; {
    description = "Simple, extendable and embeddable scripting language";
    homepage = "https://github.com/sagiegurari/duckscript";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "duck";
  };
}
