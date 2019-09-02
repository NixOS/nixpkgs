{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "quicktemplate";
  version = "unstable-2019-07-08";
  goPackagePath = "github.com/valyala/quicktemplate";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "840e9171940bbc80bb1b925c880664cababae022";
    sha256 = "1pimf5bwivklsr438if6l8by34gr48a05gl6hq07cvc8z6wl01m2";
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
