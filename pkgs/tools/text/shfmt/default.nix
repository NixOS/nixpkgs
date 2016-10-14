{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "shfmt-${version}";
  version = "0.2.0";
  rev = "v${version}";

  goPackagePath = "github.com/mvdan/sh";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    inherit rev;
    sha256 = "07jf9v6583vvmk07fp7xdlnh7rvgl6f06ib2588g3xf1wk9vrq3d";
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
