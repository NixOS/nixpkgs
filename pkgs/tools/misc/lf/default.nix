{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lf-unstable-${version}";
  version = "2016-10-02";

  goPackagePath = "github.com/gokcehan/lf";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "7a851f6c720380a6b9f715542906a56334e7e98b"; # nightly
    sha256 = "0hdxcibly3algz0hgy65xr3dxchf4aarpxdgxsgc67m1knizksjr";
  };

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
