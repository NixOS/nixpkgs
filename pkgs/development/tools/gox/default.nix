{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gox-${version}";
  version = "20181025";

  goPackagePath = "github.com/mitchellh/gox";

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "gox";
    rev = "9cc487598128d0963ff9dcc51176e722788ec645";
    sha256 = "18indkdwq2m1wy95d71lgbf46jxxrfc5km1fys5laapz993h77v6";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/mitchellh/gox;
    description = "A dead simple, no frills Go cross compile tool";
    platforms = platforms.all;
    license = licenses.mpl20;
  };

}
