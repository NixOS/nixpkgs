{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "shibboleth";
  version = "2.0.1-unstable-2020-09-04";

  src = fetchFromGitHub {
    owner = "nginx-shib";
    repo = "nginx-http-shibboleth";
    rev = "3f5ff4212fa12de23cb1acae8bf3a5a432b3f43b";
    hash = "sha256-xsPzEhT6gEma8W2u779JSfkBcw27cfzYmzGer26U34w=";
  };

  meta = {
    description = "Shibboleth auth request";
    homepage = "https://github.com/nginx-shib/nginx-http-shibboleth";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
