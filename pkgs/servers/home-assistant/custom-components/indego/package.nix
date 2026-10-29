{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyindego,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "sander1988";
  domain = "indego";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "sander1988";
    repo = "Indego";
    tag = finalAttrs.version;
    hash = "sha256-CCE1TXM8syzeKstiFhM/Gip6BHmppgAqHrarYJjzqV4=";
  };

  dependencies = [ pyindego ];

  meta = {
    description = "Bosch Indego lawn mower component";
    changelog = "https://github.com/sander1988/Indego/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/sander1988/Indego";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
