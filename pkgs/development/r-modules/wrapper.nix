{ stdenv, R, libcxx, makeWrapper, recommendedPackages, packages }:

stdenv.mkDerivation {
  name = R.name + "-wrapper";

  buildInputs = [makeWrapper R] ++ recommendedPackages ++ packages
    ++ stdenv.lib.optionals stdenv.isDarwin R.darwinFrameworks;

  NIX_CFLAGS_COMPILE =
    stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cd ${R}/bin
    for exe in *; do
      makeWrapper ${R}/bin/$exe $out/bin/$exe \
        --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
    done
  '';
}
