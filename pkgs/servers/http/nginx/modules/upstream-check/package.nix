{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "upstream-check";
  version = "0.3.0-unstable-2019-11-03";

  src = fetchFromGitHub {
    owner = "yaoweibin";
    repo = "nginx_upstream_check_module";
    rev = "e538034b6ad7992080d2403d6d3da56e4f7ac01e";
    hash = "sha256-lJzVs+B/1VjGiQeDyl0md/6o1AYVgeWxx7+LAwiYxxs=";
  };

  meta = {
    description = "Support upstream health check";
    homepage = "https://github.com/yaoweibin/nginx_upstream_check_module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
