{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchNpmDeps,
  aiofiles,
  bcrypt,
  jinja2,
  joserfc,
  nodejs,
  npmHooks,
  python-jose,
}:

buildHomeAssistantComponent rec {
  owner = "christaangoossens";
  domain = "auth_oidc";
  version = "0.6.5-alpha";

  src = fetchFromGitHub {
    owner = "christiaangoossens";
    repo = "hass-oidc-auth";
    tag = "v${version}";
    hash = "sha256-nclrSO6KmPnwXRPuuFwR6iYHsyfqcelPRGERWVJpdyk=";
  };

  postPatch = ''
    rm custom_components/auth_oidc/static/style.css
  '';

  env.npmDeps = fetchNpmDeps {
    name = "${domain}-npm-deps";
    inherit src;
    hash = "sha256-i75YeCZVSMFDWzaiDJRTYqQee5I15n9ll0YYX1PXYbA=";
  };

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  dependencies = [
    aiofiles
    bcrypt
    jinja2
    joserfc
    python-jose
  ];

  postBuild = ''
    npm run css
  '';

  meta = {
    changelog = "https://github.com/christiaangoossens/hass-oidc-auth/releases/tag/v${version}";
    description = "OpenID Connect authentication provider for Home Assistant";
    homepage = "https://github.com/christiaangoossens/hass-oidc-auth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
