{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "cache-purge";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "nginx-modules";
    repo = "ngx_cache_purge";
    tag = finalAttrs.version;
    hash = "sha256-kjZbHXaDCh4EHK59XuIISZ0xcgd2c+plwrXvqB+2S1E=";
  };

  meta = {
    description = "Adds ability to purge content from FastCGI, proxy, SCGI and uWSGI caches";
    homepage = "https://github.com/nginx-modules/ngx_cache_purge";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
