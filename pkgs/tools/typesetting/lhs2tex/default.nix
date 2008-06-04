{stdenv, fetchurl, tetex, polytable, ghc}:

assert tetex == polytable.tetex;

stdenv.mkDerivation {
  name = "lhs2tex-1.13";
  
  src = fetchurl {
    url = "http://people.cs.uu.nl/andres/lhs2tex/lhs2tex-1.13.tar.gz";
    sha256 = "28282cb4afcc71785b092d358ffb33f5ec7585e50b392ae4fb6391d495a0836b";
  };

  buildInputs = [tetex ghc];
  propagatedBuildInputs = [polytable];
  propagatedUserEnvPackages = [polytable];

  postInstall = ''
    ensureDir "$out/share/doc/$name"
    cp doc/Guide2.pdf $out/share/doc/$name
    ensureDir "$out/nix-support"
    echo "$propagatedUserEnvPackages" > $out/nix-support/propagated-user-env-packages
  '';

  inherit tetex;
}

