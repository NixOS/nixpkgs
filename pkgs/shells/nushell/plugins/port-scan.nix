{
  stdenv,
  runCommand,
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
  CoreFoundation,
  IOKit,
  nushell,
  nushell-plugin-port-scan,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell-plugin-port-scan";
  version = "1.0.1-unstable-2024-12-23";

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_port_scan";
    rev = "c3307b4bc135621a14a140ed2a8c2b51fd7c070c";
    hash = "sha256-S0tM3KlC2S1VLZt9lyVif/aGDLMo8U0svS8KmtGUKxE=";
  };

  cargoHash = "sha256-8QAtHkbXm13cQEriQVH7i030w9i7mgFCD04E5sYP9Q8=";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreFoundation
    IOKit
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.check =
      let
        nu = lib.getExe nushell;
        plugin = lib.getExe nushell-plugin-port-scan;
      in
      runCommand "${pname}-test" { } ''
        touch $out
        ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
        ${nu} -n -c "plugin use --plugin-config $out port_scan"
      '';
  };

  meta = with lib; {
    description = "A nushell plugin for scanning ports on a target";
    mainProgram = "nu_plugin_port_scan";
    homepage = "https://github.com/FMotalleb/nu_plugin_port_scan";
    license = licenses.mit;
    maintainers = with maintainers; [ aftix ];
    platforms = with platforms; all;
  };
}
