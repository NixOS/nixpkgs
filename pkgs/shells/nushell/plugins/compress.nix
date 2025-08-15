{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_compress";
  version = "0.2.7-unstable-15-06-2025";

  src = fetchFromGitHub {
    owner = "yybit";
    repo = "nu_plugin_compress";
    rev = "bc75b1b7758a88379eb0b162b8bd6185a05c82a2";
    hash = "sha256-PSN82Di3v5J6ulJpSI1bKfKFQgBVC6HV7m+KwW76JGI=";
  };

  cargoHash = "sha256-ld6vqNs7p5ri3d6//mLA5+hrrhGFR8yA6f8hLFOx7R8=";

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "${lib.head (lib.splitString "-" finalAttrs.version)}"' 'version = "${finalAttrs.version}"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for compression and decompression";
    mainProgram = "nu_plugin_compress";
    homepage = "https://github.com/yybit/nu_plugin_compress";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timon ];
    platforms = lib.platforms.linux;
  };
})
