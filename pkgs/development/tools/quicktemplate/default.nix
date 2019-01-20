{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "quicktemplate-unstable-${version}";
  version = "2018-11-26";
  goPackagePath = "github.com/valyala/quicktemplate";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "4c04039b1358b0f49af22a699f9193f05d80be40";
    sha256 = "1qf7wpalk3n2jmcc2sw05cnwysl4rx986avykbfic5wq4fgxh9a5";
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
