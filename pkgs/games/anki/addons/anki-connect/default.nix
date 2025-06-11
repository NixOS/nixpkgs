{
  lib,
  anki-utils,
  fetchFromSourcehut,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-connect";
  version = "24.7.25.0";
  src = fetchFromSourcehut {
    owner = "~foosoft";
    repo = "anki-connect";
    rev = finalAttrs.version;
    hash = "sha256-N98EoCE/Bx+9QUQVeU64FXHXSek7ASBVv1b9ltJ4G1U=";
  };
  sourceRoot = "${finalAttrs.src.name}/plugin";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = ''
      Enable external applications such as Yomichan to communicate
      with Anki over a simple HTTP API
    '';
    homepage = "https://foosoft.net/projects/anki-connect/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ junestepp ];
  };
})
