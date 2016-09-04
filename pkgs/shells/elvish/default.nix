{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-${version}";
  version = "0.1";

  goPackagePath = "github.com/elves/elvish";

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = "4125c2bb927330b0100b354817dd4ad252118ba6";
    sha256 = "1xwhjbw0y6j5xy19hz39456l0v6vjg2icd7c1jx4h1cydk3yn39f";
  };

  goDeps = ./deps.json;

  meta = with stdenv.lib; {
    description = "A Novel unix shell in go language";
    homepage = https://github.com/elves/elvish;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; [ linux ];
  };
}
