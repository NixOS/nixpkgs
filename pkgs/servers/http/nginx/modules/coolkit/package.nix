{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "coolkit";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "FRiCKLE";
    repo = "ngx_coolkit";
    tag = finalAttrs.version;
    hash = "sha256-EF/psh+aXUc1FRPrGUqczYFjsHYhX8wkV7hpVzEDssU=";
  };

  meta = {
    description = "Collection of small and useful nginx add-ons";
    homepage = "https://github.com/FRiCKLE/ngx_coolkit";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
