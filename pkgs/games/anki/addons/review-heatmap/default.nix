{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "review-heatmap";
  version = "0-unstable-2025-8-1";
  src = fetchFromGitHub {
    owner = "glutanimate";
    repo = "review-heatmap";
    rev = finalAttrs.version;
    sparseCheckout = ["src/addon"];
    hash = "sha256-28DJq2l9DP8O6OsbNQCZ0pm4S6CQ3Yz0Vfvlj+iQw8Y=";
  };
  sourceRoot = "${finalAttrs.src.name}/src/addon";
  passthru.updateScript = nix-update-script {};
  meta = {
    description = "Add a heatmap graph to Anki to visulaize your past and future card-review activity";
    homepage = "https://github.com/glutanimate/review-heatmap";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [dastarruer];
  };
})
