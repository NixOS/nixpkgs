{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  msgpuck,
  yajl,
}:

mkNginxPlugin (finalAttrs: {
  pname = "upstream-tarantool";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "tarantool";
    repo = "nginx_upstream_module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eZECvMwpepPERg64bVGSwYJ5WSRbtlM4/vIfG8EYRHk=";
  };

  buildInputs = [
    msgpuck.dev
    yajl
  ];

  meta = {
    description = "Tarantool NginX upstream module (REST, JSON API, websockets, load balancing)";
    homepage = "https://github.com/tarantool/nginx_upstream_module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };

})
