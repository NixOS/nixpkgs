{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_net";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    tag = "${finalAttrs.version}";
    hash = "sha256-HiNydU40FprxVmRRZtnXom2kFYI04mbeuGTq8+BMh7o=";
  };

  cargoHash = "sha256-tq0XqY2B7tC2ep8vH6T3nkAqxqhniqzYnhbkfB3SbHU=";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  # there are no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin to list system network interfaces";
    homepage = "https://github.com/fennewald/nu_plugin_net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "nu_plugin_net";
    # "Plugin `net` is compiled for nushell version 0.104.0, which is not
    # compatible with version 0.105.1"
    broken = true;
  };
})
