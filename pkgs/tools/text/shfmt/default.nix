{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "shfmt-${version}";
  version = "2016-06-16";
  rev = "8add0072d6abdc892e4617c95e8bba21ebe0beeb";

  goPackagePath = "github.com/mvdan/sh";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    inherit rev;
    sha256 = "1m2lkcw6m5gdqjp17m01d822cj1p04qk6hm9m94ni2x19f16qs8m";
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
