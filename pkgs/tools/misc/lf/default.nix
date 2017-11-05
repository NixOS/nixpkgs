{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lf-unstable-${version}";
  version = "2017-10-30";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "3f7bd0a62d1a243562e182d9051ebb54f3414aaa"; # nightly
    sha256 = "0g6wf4j3dfy3yfkby3wlqajryv4kffqvhljq2q0x482fsrl4vipz";
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
