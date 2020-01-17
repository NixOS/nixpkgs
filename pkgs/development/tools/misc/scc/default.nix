{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "scc";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${version}";
    sha256 = "1g55aahr8j93jc1k2zgpnyxgp7ddn5137vjf8dafsmqp4m2qjq6g";
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
