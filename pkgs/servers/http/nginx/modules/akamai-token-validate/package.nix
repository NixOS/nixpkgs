{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  openssl,
}:

mkNginxPlugin (finalAttrs: {
  pname = "akamai-token-validate";
  version = "0-unstable-2026-06-26";

  src = fetchFromGitHub {
    owner = "kaltura";
    repo = "nginx-akamai-token-validate-module";
    rev = "34fd0c94d2c43c642f323491c4f4a226cd83b962";
    hash = "sha256-nh0l5txpQAn5lBOeujfSMN1Rn5XP0MUHoGy+HYImw3k=";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "Validates Akamai v2 query string tokens";
    homepage = "https://github.com/kaltura/nginx-akamai-token-validate-module";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
})
