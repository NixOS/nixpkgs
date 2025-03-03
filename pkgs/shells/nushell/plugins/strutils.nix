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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = pname;
    tag = "0.9.0";
    hash = "sha256-xictRAkMnVEbNjEVO4w9XN0auHX5mcmnyFdlaFoVunA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4r5TH3t61TjWMoKuzStuUQM779IpD1t4K98OuOQ2L8M=";

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
    platforms = platforms.all;
  };
}
