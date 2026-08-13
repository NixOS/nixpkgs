{
  lib,
  fetchFromGitHub,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "develkit";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "vision5";
    repo = "ngx_devel_kit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SXQ5KC8X9nKLbntXjEziCqJVeiX+lnBKruAVVVcexaM=";
  };

  meta = {
    description = "Adds additional generic tools that module developers can use in their own modules";
    homepage = "https://github.com/vision5/ngx_devel_kit";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
