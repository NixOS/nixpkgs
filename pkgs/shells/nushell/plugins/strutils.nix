{
  stdenv,
  runCommand,
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  IOKit,
  CoreFoundation,
  nushell,
  strutils,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_strutils";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gf+vLe3kertyEoFN2zUVPRtyEIiEsTmtYgUGJE7SGCs=";
  };

  cargoHash = "sha256-HU306iSHTyeRern6Ix2SbyEUq6h4u4dFMoNNH2uQAz4=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    IOKit
    CoreFoundation
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.check =
      let
        nu = lib.getExe nushell;
        plugin = lib.getExe strutils;
      in
      runCommand "${pname}-test" { } ''
        touch $out
        ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
        ${nu} -n -c "plugin use --plugin-config $out strutils"
      '';
  };

  meta = with lib; {
    description = "A nushell plugin that implements additional string utilities beyond the built-in commands";
    mainProgram = "nu_plugin_strutils";
    homepage = "https://github.com/fdncred/nu_plugin_strutils";
    license = licenses.mit;
    maintainers = with maintainers; [ aftix ];
    platforms = with platforms; all;
  };
}
