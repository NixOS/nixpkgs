{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "shfmt-${version}";
  version = "1.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/mvdan/sh";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    inherit rev;
    sha256 = "0h1qy27z6j1cgkk3hkvl7w3wjqc5flgn92r3j6frn8k2wzwj7zhz";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/mvdan/sh;
    description = "A shell parser and formatter";
    longDescription = ''
      shfmt formats shell programs. It can use tabs or any number of spaces to indent.
      You can feed it standard input, any number of files or any number of directories to recurse into.
    '';
    license = licenses.bsd3;
  };
}
