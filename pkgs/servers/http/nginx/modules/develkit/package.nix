{
  lib,
  fetchFromGitHub,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "develkit";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "vision5";
    repo = "ngx_devel_kit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/RQUVHwIdNqm3UemQ/oNs2ksg8beziA4Pxejd5Yg0Pg=";
  };

  meta = {
    description = "Adds additional generic tools that module developers can use in their own modules";
    homepage = "https://github.com/vision5/ngx_devel_kit";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
