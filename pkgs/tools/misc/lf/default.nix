{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lf-unstable-${version}";
  version = "2018-03-19";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "c76ad181f5753984e39608628ac4def4183b53a4"; # nightly
    sha256 = "1wsmljina9n2zij7gzh7b4zbzi7sdsa6hnyaj75nsmqn9lshngap";
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
