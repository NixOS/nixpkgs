{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "puppy-reinforcement";
  version = "1.1.1";
  src = fetchFromGitHub {
    owner = "glutanimate";
    repo = "puppy-reinforcement";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y52AjmYrFTcTwd4QAcJzK5R9wwxUSlvnN3C2O/r5cHk=";
  };
  sourceRoot = "${finalAttrs.src.name}/src/puppy_reinforcement";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Anki add-on that encourages learners with pictures of cute puppies";
    homepage = "https://ankiweb.net/shared/info/1722658993";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lomenzel ];
  };
})
