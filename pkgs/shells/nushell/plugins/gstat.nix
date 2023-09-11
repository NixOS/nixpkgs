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
  version = "0.84.0";
  src = nushell.src;
  cargoHash = "sha256-RcwCYfIEV0+NbZ99uWaCOLqLap3wZ4qXIsc02fqkBSQ=";
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
