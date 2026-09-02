{
  lib,
  fetchFromGitHub,
  mkNginxPlugin,
  openssl,
}:

mkNginxPlugin (finalAttrs: {
  pname = "secure-token";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "kaltura";
    repo = "nginx-secure-token-module";
    tag = finalAttrs.version;
    hash = "sha256-qYTjGS9pykRqMFmNls52YKxEdXYhHw+18YC2zzdjEpU=";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "Generates CDN tokens, either as a cookie or as a query string parameter";
    homepage = "https://github.com/kaltura/nginx-secure-token-module";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
})
