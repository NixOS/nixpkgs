{ appleDerivation', stdenvNoCC }:

# Unfortunately, buiding libmalloc is not feasible due to its use of non-public headers, but its
# headers are needed by Libsystem.
appleDerivation' stdenvNoCC {
  installPhase = ''
    mkdir -p $out/include
    cp -R include/malloc $out/include/
  '';
}
