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
    sha256 = "1x5hm6r0dkm02ffny8kjd7mmq8przyd9amg2qvy5700x6lb63pbs";
  };

  meta = {
    description = "Implements a collection of augmented statistics based on HTTP-codes and upstreams response time";
    homepage = "https://github.com/goldenclone/nginx-sla";
    license = lib.licenses.unfree; # no license in repo
    maintainers = [ ];
  };
})
