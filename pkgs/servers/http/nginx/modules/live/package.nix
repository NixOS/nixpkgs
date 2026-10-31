{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "live";
  version = "0-unstable-2018-11-18";

  src = fetchFromGitHub {
    owner = "arut";
    repo = "nginx-live-module";
    rev = "5e4a1e3a718e65e5206c24eba00d42b0d1c4b7dd";
    hash = "sha256-n4ZEnl84smKF138WtBTakmDXfcdQCfEJqvGDsgiF9s4=";
  };

  meta = {
    description = "HTTP live module";
    homepage = "https://github.com/arut/nginx-live-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
