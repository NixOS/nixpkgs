{stdenv, fetchurl, ghc}:

stdenv.mkDerivation (rec {
  pname = "haddock";
  version = "2.0.0.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "http://hackage.haskell.org/packages/archive/${pname}/${version}/${name}.tar.gz";
    sha256 = "a2ea5bdc127bc8b189a8d869f582ec774fea0933e7f5ca89549a6c142b9993df";
  };
  buildInputs = [ghc];

  configurePhase = '' 
    ghc --make Setup.lhs
    ./Setup configure -v --prefix="$out"
  '';

  buildPhase = ''
    ./Setup build
  '';

  installPhase = ''
    ./Setup install
  '';
})
