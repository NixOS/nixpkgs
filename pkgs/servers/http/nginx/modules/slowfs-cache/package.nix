{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "slowfs-cache";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "FRiCKLE";
    repo = "ngx_slowfs_cache";
    tag = finalAttrs.version;
    hash = "sha256-uddV7vlc7SqnRp5L36+yr6wGylNjwxsq/kNzdgVQ378=";
  };

  meta = {
    description = "Adds ability to cache static files";
    homepage = "https://github.com/friCKLE/ngx_slowfs_cache";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };

})
