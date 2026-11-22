{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  version = "1.3.9";
  domain = "econet300";
  owner = "jontofront";

  src = fetchFromGitHub {
    owner = "jontofront";
    repo = "ecoNET-300-Home-Assistant-Integration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K4QWDf+yueckqYdg/geHWG+G6PHTcWzXPRb816kju1M=";
  };

  meta = {
    changelog = "https://github.com/jontofront/ecoNET-300-Home-Assistant-Integration/releases/tag/v${finalAttrs.version}";
    description = "Home Assistant component for Plum ecoNET300 devices";
    homepage = "https://github.com/jontofront/ecoNET-300-Home-Assistant-Integration";
    maintainers = with lib.maintainers; [ implr ];
    license = lib.licenses.mit;
  };
})
