{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_highlight";
  version = "1.4.9+0.107.0";

  src = fetchFromGitHub {
    owner = "cptpiepmatz";
    repo = "nu-plugin-highlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y+IGbgQ2DOHMKlImqvt819aeXrQ5td00rjHFimzrOz8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-vTxDgdwoKRM4AIMqQPWKqYsO7tvdeHpunq6nsctoblg=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  # there are no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "`nushell` plugin for syntax highlighting";
    mainProgram = "nu_plugin_highlight";
    homepage = "https://github.com/cptpiepmatz/nu-plugin-highlight";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aciceri
      mgttlinger
    ];
  };
})
