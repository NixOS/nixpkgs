{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "fancyindex";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "ngx-fancyindex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-97HCAm3hcgrwyOvBEwC+vcVkuuzedgHC67+w8OK2bEQ=";
  };

  meta = {
    description = "Fancy indexes module";
    homepage = "https://github.com/aperezdc/ngx-fancyindex";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aneeshusa ];
  };
})
