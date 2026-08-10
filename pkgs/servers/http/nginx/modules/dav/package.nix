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
    sha256 = "000dm5zk0m1hm1iq60aff5r6y8xmqd7djrwhgnz9ig01xyhnjv9w";
  };

  buildInputs = [ expat ];

  meta = {
    description = "WebDAV PROPFIND,OPTIONS,LOCK,UNLOCK support";
    homepage = "https://github.com/arut/nginx-dav-ext-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
