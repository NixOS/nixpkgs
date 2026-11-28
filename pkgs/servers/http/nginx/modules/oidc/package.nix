{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  hiredis,
  jansson,
}:
mkNginxPlugin (finalAttrs: {
  pname = "oidc";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "nginx-oidc";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-jwTzUwkPUlnuZ497k8eae3vzjWlAllewngrtM5Bhv8g=";
  };

  buildInputs = [
    hiredis
    jansson
  ];

  meta = {
    description = "nginx module for the OIDC";
    homepage = "https://github.com/kjdev/nginx-oidc";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
})
