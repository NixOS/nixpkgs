{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lf-unstable-${version}";
  version = "2017-02-04";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "c55c4bf254d59c4e943d5559cd6e062652751e36"; # nightly
    sha256 = "0jq85pfhpzdplv083mxbys7pp8igcvhp4daa9dh0yn4xbd8x821d";
  };

  goPackagePath = "github.com/gokcehan/lf";
  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = "https://godoc.org/github.com/gokcehan/lf";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
