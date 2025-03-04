{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  aiofiles,
  bcrypt,
  jinja2,
  python-jose,
}:

buildHomeAssistantComponent rec {
  owner = "christaangoossens";
  domain = "auth_oidc";
  version = "0.6.2-alpha";

  src = fetchFromGitHub {
    owner = "christiaangoossens";
    repo = "hass-oidc-auth";
    tag = "v${version}";
    hash = "sha256-C/Nui0frlcRLaOqsfFH72QNo756karLq/UUcvs2LgE0=";
  };

  dependencies = [
    aiofiles
    bcrypt
    jinja2
    python-jose
  ];

  meta = {
    changelog = "https://github.com/christiaangoossens/hass-oidc-auth/releases/tag/v${version}";
    description = "OpenID Connect authentication provider for Home Assistant";
    homepage = "https://github.com/christiaangoossens/hass-oidc-auth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
