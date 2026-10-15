{
  lib,
  fetchFromGitHub,
  mkNginxPlugin,
  expat,
}:

mkNginxPlugin (finalAttrs: {
  pname = "dav";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "arut";
    repo = "nginx-dav-ext-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PG1poe8BvJi+fZBn2U7DtSNvcnFOAYNjqDBUMH+pDQA=";
  };

  buildInputs = [ expat ];

  meta = {
    description = "WebDAV PROPFIND,OPTIONS,LOCK,UNLOCK support";
    homepage = "https://github.com/arut/nginx-dav-ext-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
