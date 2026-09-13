{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  version = "1.3.3a";
  domain = "econet300";
  owner = "jontofront";

  src = fetchFromGitHub {
    owner = "jontofront";
    repo = "ecoNET-300-Home-Assistant-Integration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YFD24/ghX/uDzAYmAFh3GVNaUHArJJctTJPMLpmw24Y=";
  };

  meta = {
    changelog = "https://github.com/jontofront/ecoNET-300-Home-Assistant-Integration/releases/tag/v${finalAttrs.version}";
    description = "Home Assistant component for Plum ecoNET300 devices";
    homepage = "https://github.com/jontofront/ecoNET-300-Home-Assistant-Integration";
    maintainers = with lib.maintainers; [ implr ];
    license = lib.licenses.unfree;
  };
})
