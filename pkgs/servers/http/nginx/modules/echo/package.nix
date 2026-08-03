{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "echo";
  version = "0.63";

  src = fetchFromGitHub {
    name = "echo";
    owner = "openresty";
    repo = "echo-nginx-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K7oOE0yxPYLf+3YMVbBsncpHRpGHXjs/8B5QPO3MQC4=";
  };

  meta = {
    description = "Brings echo, sleep, time, exec and more shell-style goodies to Nginx";
    homepage = "https://github.com/openresty/echo-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
