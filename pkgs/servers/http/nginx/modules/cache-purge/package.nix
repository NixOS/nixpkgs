{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "cache-purge";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "nginx-modules";
    repo = "ngx_cache_purge";
    tag = finalAttrs.version;
    hash = "sha256-i7TJGC4E6AX3+BYCK/NfYEx976h7Txu03+QgbOUWNKk=";
  };

  meta = {
    description = "Adds ability to purge content from FastCGI, proxy, SCGI and uWSGI caches";
    homepage = "https://github.com/nginx-modules/ngx_cache_purge";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
