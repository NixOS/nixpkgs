{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lf-unstable-${version}";
  version = "2017-09-06";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "ae4a29e5501f805fadb115658e83df6744a258b2"; # nightly
    sha256 = "099ckbnyk08a716fc5qz7yldalb1p9gn2zn8kqp7bp4adi541hid";
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
