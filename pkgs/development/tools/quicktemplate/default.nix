{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "quicktemplate-unstable-${version}";
  version = "2019-01-31";
  goPackagePath = "github.com/valyala/quicktemplate";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "d08324ac14fa81325830fae7eb30188ec68427f8";
    sha256 = "0gpc1kcqvcn1f9mz2dww8bhrspnsk2fgxzvx398vy7a0xhxq8vhx";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/valyala/quicktemplate";
    description = "Fast, powerful, yet easy to use template engine for Go";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
