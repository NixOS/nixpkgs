{
  lib,
  runCommand,
  R,
  radian,
  makeWrapper,
  recommendedPackages,
  packages,
  wrapR ? false,
}:

runCommand (radian.name + "-wrapper")
  {

    buildInputs = [
      R
      radian
    ]
    ++ recommendedPackages
    ++ packages;

    nativeBuildInputs = [ makeWrapper ];

    passthru = { inherit recommendedPackages; };

    meta = radian.meta // {
      # To prevent builds on hydra
      hydraPlatforms = [ ];
      # prefer wrapper over the package
      priority = (radian.meta.priority or lib.meta.defaultPriority) - 1;
    };
  }
  (
    ''
      makeWrapper "${radian}/bin/radian" "$out/bin/radian" \
        --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
    ''
    + lib.optionalString wrapR ''
      cd ${R}/bin
      for exe in *; do
        makeWrapper "${R}/bin/$exe" "$out/bin/$exe" \
          --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
      done
    ''
  )
