{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "quicktemplate-unstable-${version}";
  version = "2018-09-06";
  goPackagePath = "github.com/valyala/quicktemplate";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "dc50ff9977a68a543145ce34e0e0030bebcc89be";
    sha256 = "1980q2c5w4jhrlhf1pimc8yrkz005x3jbsi7hk4hnx6d5iy5lmb6";
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
