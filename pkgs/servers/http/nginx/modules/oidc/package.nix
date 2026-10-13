{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  hiredis,
  jansson,
}:
mkNginxPlugin (finalAttrs: {
  pname = "oidc";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "nginx-oidc";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-d1be3U7ybfYDCoLYdIDp9JEs29+NMFTr16SRj5vOX0w=";
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
