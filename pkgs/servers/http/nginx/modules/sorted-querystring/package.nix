{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "sorted-querystring";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "wandenberg";
    repo = "nginx-sorted-querystring-module";
    tag = finalAttrs.version;
    hash = "sha256-Rz5ylx1e/gukwphANc06m92xIJnpdtLdETYNzRkEy1w=";
  };

  meta = {
    description = "Expose querystring parameters sorted in a variable";
    homepage = "https://github.com/wandenberg/nginx-sorted-querystring-module";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
