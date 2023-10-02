{ stdenv
, lib
, rustPlatform
, openssl
, nushell
, pkg-config
, Security
}:

let
  pname = "nushell_plugin_gstat";
in
rustPlatform.buildRustPackage {
  inherit pname;
  version = "0.85.0";
  src = nushell.src;
  cargoHash = "sha256-6luY3SIRRd9vaY9KIJcj8Q974FW0LtAvRjVpdpzkdLo=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  cargoBuildFlags = [ "--package nu_plugin_gstat" ];
  doCheck = false; # some tests fail
  meta = with lib; {
    description = "A git status plugin for Nushell";
    homepage = "https://github.com/nushell/nushell/tree/main/crates/nu_plugin_gstat";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mrkkrp ];
    platforms = with platforms; all;
  };
}
