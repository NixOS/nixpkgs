{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "push-stream";
  version = "0.5.4-unstable-2020-05-03";

  src = fetchFromGitHub {
    owner = "wandenberg";
    repo = "nginx-push-stream-module";
    rev = "1cdc01521ed44dc614ebb5c0d19141cf047e1f90";
    hash = "sha256-WUoAr0d4M4JglDd/puQgPYqhymqIUCnmAbSdscRQU0Y=";
  };

  meta = {
    description = "Pure stream http push technology";
    homepage = "https://github.com/wandenberg/nginx-push-stream-module";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    broken = true;
  };
})
