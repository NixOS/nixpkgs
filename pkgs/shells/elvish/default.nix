{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-${version}";
  version = "0.5";

  goPackagePath = "github.com/elves/elvish";

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = version;
    sha256 = "1dk5f8a2wpgd5cw45ippvx46fxk0yap64skfpzpiqz8bkbnrwbz6";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A Novel unix shell in go language";
    homepage = https://github.com/elves/elvish;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; linux;
  };
}
