{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-${version}";
  version = "0.11";

  goPackagePath = "github.com/elves/elvish";

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = version;
    sha256 = "1rzgy1ql381nwsdjgiwv4mdr1xwivnpmzgkdzms8ipn2lbwhff87";
  };

  meta = with stdenv.lib; {
    description = "A friendly and expressive Unix shell";
    homepage = https://github.com/elves/elvish;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; linux ++ darwin;
  };
}
