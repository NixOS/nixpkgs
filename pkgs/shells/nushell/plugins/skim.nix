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
  skim,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_skim";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "idanarye";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cPM4Z1o2ED8Q5u9AcnwBv+SOvuE2C4NO9xC7PfX+ntk=";
  };

  cargoHash = "sha256-93GSnw/3Ms83bYEyRRc2sguUpR7BIWz8hgqzXdU5CF4=";

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
        plugin = lib.getExe skim;
      in
      runCommand "${pname}-test" { } ''
        touch $out
        ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
        ${nu} -n -c "plugin use --plugin-config $out skim"
      '';
  };

  meta = with lib; {
    description = "A nushell plugin that adds integrates the skim fuzzy finder";
    mainProgram = "nu_plugin_skim";
    homepage = "https://github.com/idanarye/nu_plugin_skim";
    license = licenses.mit;
    maintainers = with maintainers; [ aftix ];
    platforms = platforms.all;
  };
}
