{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "sla";
  version = "0-unstable-2015-09-21";

  src = fetchFromGitHub {
    owner = "goldenclone";
    repo = "nginx-sla";
    rev = "7778f0125974befbc83751d0e1cadb2dcea57601";
    hash = "sha256-et1hFjUdgFP8xuJVlZr/+SJc62lyIm+dE6DOBrKpsPQ=";
  };

  meta = {
    description = "Implements a collection of augmented statistics based on HTTP-codes and upstreams response time";
    homepage = "https://github.com/goldenclone/nginx-sla";
    license = lib.licenses.unfree; # no license in repo
    maintainers = [ ];
  };
})
