{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "shfmt-${version}";
  version = "2016-06-15";
  rev = "233b276a55cdd4aaa4625893255382993bbb0533";

  goPackagePath = "github.com/mvdan/sh";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    inherit rev;
    sha256 = "09rq99gw2g6az6dmdg82nql8zp3c3mrqavqwvx76dirabzjhsbj6";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/mvdan/sh;
    description = "A shell parser and formatter";
    longDescription = ''
      shfmt formats shell programs. It can use tabs or any number of spaces to indent.
      You can feed it standard input, any number of files or any number of directories to recurse into.
    '';
  };
}
