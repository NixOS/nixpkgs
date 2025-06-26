{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_plot";
  version = "0.103.0-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "Euphrasiologist";
    repo = "nu_plugin_plot";
    rev = "5a1ca2a5ceba60108a4ca6d45ec18d213abb5227";
    hash = "sha256-yxohLQnXMxztkPshVc9uZReMT1EZkwlnORTX5UAUXsA=";
  };

  cargoHash = "sha256-5QkB6SQReWUMgUL6JS0nYR+qoGLRDnDK4fpcBmgoMp4=";

  postPatch = ''
    # disable failing doctest
    echo -e "[lib]\ndoctest = false\n" >> Cargo.toml

    substituteInPlace Cargo.toml \
      --replace-fail 'version = "${lib.head (lib.splitString "-" finalAttrs.version)}"' 'version = "${finalAttrs.version}"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for plotting a list as a line graph";
    mainProgram = "nu_plugin_plot";
    homepage = "https://github.com/Euphrasiologist/nu_plugin_plot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
    platforms = lib.platforms.linux;
  };
})
