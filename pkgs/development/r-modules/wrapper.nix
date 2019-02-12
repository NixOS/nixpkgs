{ runCommand, R, makeWrapper, recommendedPackages, packages }:

runCommand (R.name + "-wrapper") {
  preferLocalBuild = true;
  allowSubstitutes = false;

  buildInputs = [R] ++ recommendedPackages ++ packages;

  nativeBuildInputs = [makeWrapper];

  # Make the list of recommended R packages accessible to other packages such as rpy2
  passthru = { inherit recommendedPackages; };
}
''
mkdir -p $out/bin
cd ${R}/bin
for exe in *; do
  makeWrapper ${R}/bin/$exe $out/bin/$exe \
    --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
done
''
