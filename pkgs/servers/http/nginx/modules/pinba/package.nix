{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "pinba";
  version = "0-unstable-2019-05-13";

  src = fetchFromGitHub {
    owner = "tony2001";
    repo = "ngx_http_pinba_module";
    rev = "28131255d4797a7e2f82a6a35cf9fc03c4678fe6";
    sha256 = "00fii8bjvyipq6q47xhjhm3ylj4rhzmlk3qwxmfpdn37j7bc8p8c";
  };

  meta = {
    description = "Pinba module for nginx";
    homepage = "https://github.com/tony2001/ngx_http_pinba_module";
    license = lib.licenses.unfree; # no license in repo
    maintainers = [ ];
  };
})
