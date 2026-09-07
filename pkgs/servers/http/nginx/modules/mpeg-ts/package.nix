{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "mpeg-ts";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "arut";
    repo = "nginx-ts-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dffm7sYnbXI4Ecx8bq8i17Tql7Y0qUEZc0FZbrxnvYk=";
  };

  meta = {
    description = "MPEG-TS Live Module";
    homepage = "https://github.com/arut/nginx-ts-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
