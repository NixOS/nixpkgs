{ stdenv
, lib
, rustPlatform
, openssl
, nushell
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_gstat";
  inherit (nushell) version src;
  cargoHash = "sha256-6luY3SIRRd9vaY9KIJcj8Q974FW0LtAvRjVpdpzkdLo=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  cargoBuildFlags = [ "--package nu_plugin_gstat" ];
  checkPhase = ''
    cargo test --manifest-path crates/nu_plugin_gstat/Cargo.toml
  '';
  meta = with lib; {
    description = "A git status plugin for Nushell";
    homepage = "https://github.com/nushell/nushell/tree/${version}/crates/nu_plugin_gstat";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mrkkrp ];
    platforms = with platforms; all;
  };
}
