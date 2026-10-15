{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "sysguard";
  version = "0-unstable-2017-03-21";

  src = fetchFromGitHub {
    owner = "vozlt";
    repo = "nginx-module-sysguard";
    rev = "e512897f5aba4f79ccaeeebb51138f1704a58608";
    hash = "sha256-3cEM7yjLkZZYzeLO84D24hqviGvr79MtvAkvprnhhqU=";
  };

  meta = {
    description = "Nginx sysguard module";
    homepage = "https://github.com/vozlt/nginx-module-sysguard";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
