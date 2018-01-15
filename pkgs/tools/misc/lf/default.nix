{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lf-unstable-${version}";
  version = "2018-01-11";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "58538c802044a3a2590ebe4979f3c85d807ea2d9"; # nightly
    sha256 = "0xp5accliwz1d0nbsc6cnsv38czcfqn5nyxfndkpw8jkh8w2pm9p";
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
    homepage = https://godoc.org/github.com/gokcehan/lf;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
