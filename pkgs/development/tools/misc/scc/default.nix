{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "scc";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${version}";
    sha256 = "1wk6s9ga9rkywgqys960s6fz4agwzh3ac2l6cpcr7kca4379s28k";
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
