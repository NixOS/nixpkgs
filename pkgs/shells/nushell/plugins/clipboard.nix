{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_clipboard";
  version = "0.110.0";

  src = fetchFromGitHub {
    owner = "fmotalleb";
    repo = "nu_plugin_clipboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9SFQJJun/7Ze3+P4zNJu+U5VOjQiM5VfPieu+2fNIXA=";
  };

  cargoHash = "sha256-PC9JVWji/m0xV+bBiCh7KYfO5giF4xeaF7X6HqL1Ry4=";

  passthru.update-script = nix-update-script { };

  meta = {
    description = "A nushell plugin to copy text into clipboard or get text from it. supports json<->object/table conversion out of box";
    homepage = "https://github.com/fmotalleb/nu_plugin_clipboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "nu_plugin_clipboard";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
