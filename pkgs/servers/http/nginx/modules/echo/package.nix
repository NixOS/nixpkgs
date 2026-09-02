{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "echo";
  version = "0.65";

  src = fetchFromGitHub {
    name = "echo";
    owner = "openresty";
    repo = "echo-nginx-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DiukXNS1ZoKVMnDD/65DZxxQSS/lAKZ5b0Pp0Hs6MTc=";
  };

  meta = {
    description = "Brings echo, sleep, time, exec and more shell-style goodies to Nginx";
    homepage = "https://github.com/openresty/echo-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
