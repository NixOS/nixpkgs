{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "shfmt-${version}";
  version = "2.6.4";

  goPackagePath = "mvdan.cc/sh";
  subPackages = ["cmd/shfmt"];

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${version}";
    sha256 = "1jifac0fi0sz6wzdgvk6s9xwpkdng2hj63ldbaral8n2j9km17hh";
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
