{ lib, runCommand, R, recommendedPackages, packages, makeWrapper, radian }:

runCommand "radian-wrapper" {
  preferLocalBuild = true;
  allowSubstitutes = false;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ R ] ++ recommendedPackages ++ packages;
}
''
makeWrapper ${radian}/bin/radian $out/bin/radian \
  --set R_LIBS_SITE "$R_LIBS_SITE" \
  --set R_HOME ${R}/lib/R
''
