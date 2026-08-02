{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "fluentd";
  version = "0.3-unstable-2014-03-28";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "nginx-fluentd-module";
    rev = "8af234043059c857be27879bc547c141eafd5c13";
    hash = "sha256-tf+jrac1QGOEwQnmDPmMMvM/Tg1TXTmKysBwndovi/k=";
  };

  meta = {
    description = "Fluentd data collector";
    homepage = "https://github.com/fluent/nginx-fluentd-module";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
