{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "url";
  version = "0-unstable-2017-03-21";

  src = fetchFromGitHub {
    owner = "vozlt";
    repo = "nginx-module-url";
    rev = "9299816ca6bc395625c3683fbd2aa7b916bfe91e";
    sha256 = "0mk1gjmfnry6hgdsnlavww9bn7223idw50jlkhh5k00q5509w4ip";
  };

  meta = {
    description = "URL encoding converting module";
    homepage = "https://github.com/vozlt/nginx-module-url";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
