{
  stdenv,
  runCommand,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
  dbus,
  nushell,
  nushell_plugin_dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_dbus";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = pname;
    rev = version;
    hash = "sha256-w+0H0A+wQa4BUzKx9G2isn29IicoZsLlWCDnC3YSzek=";
  };

  cargoHash = "sha256-NuWwPfAo3qYer4eUNDQ+VR9R+uLp5WAT2mhnr/zayEI=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = [ dbus ];

  passthru = {
    updateScript = nix-update-script { };
    tests.check =
      let
        nu = lib.getExe nushell;
        plugin = lib.getExe nushell_plugin_dbus;
      in
      runCommand "${pname}-test" { } ''
        touch $out
        ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
        ${nu} -n -c "plugin use --plugin-config $out dbus"
      '';
  };

  meta = with lib; {
    description = "Nushell plugin for communicating with D-Bus";
    mainProgram = "nu_plugin_dbus";
    homepage = "https://github.com/devyn/nu_plugin_dbus";
    license = licenses.mit;
    maintainers = with maintainers; [ aftix ];
    platforms = with platforms; linux;
  };
}
