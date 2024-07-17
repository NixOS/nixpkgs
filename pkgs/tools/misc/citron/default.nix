{
  lib,
  rustPlatform,
  fetchCrate,
  dbus,
  installShellFiles,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "citron";
  version = "0.15.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-6wJ4UfiwpV9zFuBR8SYj6eBiRqQitFs7wRe5R51Z3SA=";
  };

  cargoHash = "sha256-xTmhgE4iHydhZBMrHWqQUcS9KDlZAzW2CmPGpJr40Fw=";

  buildInputs = [ dbus ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  postInstall = ''
    installManPage doc/citron.1
  '';

  meta = {
    homepage = "https://git.sr.ht/~grtcdr/citron";
    description = "System data via on-demand notifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vuimuich ];
    platforms = lib.platforms.linux;
    mainProgram = "citron";
  };
}
