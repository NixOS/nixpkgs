{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "scc";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${version}";
    sha256 = "0hbcq5qn97kr9d4q9m2p1mj3ijn8zmwycrs5bgf1kfiwr09wg2yh";
  };

  goPackagePath = "github.com/boyter/scc";

  # scc has a scripts/ sub-package that's for testing.
  subPackages = [ "./" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/boyter/scc";
    description = "A very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with maintainers; [ sigma filalex77 ];
    license = with licenses; [ unlicense /* or */ mit ];
    platforms = platforms.unix;
  };
}
