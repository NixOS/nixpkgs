{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "cache-purge";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "nginx-modules";
    repo = "ngx_cache_purge";
    tag = finalAttrs.version;
    hash = "sha256-jVm8E4u1NkjtBoGdRzUDo6l27XPDFoCrNUf2asaXRG0=";
  };

  meta = {
    description = "Adds ability to purge content from FastCGI, proxy, SCGI and uWSGI caches";
    homepage = "https://github.com/nginx-modules/ngx_cache_purge";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
