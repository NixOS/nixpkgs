{
  lib,
  runCommand,
  R,
  ark,
  makeWrapper,
  recommendedPackages,
  packages,
}:

runCommand (ark.name + "-wrapper")
  {
    preferLocalBuild = true;
    allowSubstitutes = false;

    buildInputs = [
      R
      ark
    ]
    ++ recommendedPackages
    ++ packages;

    nativeBuildInputs = [ makeWrapper ];

    passthru = { inherit recommendedPackages; };

    meta = ark.meta // {
      # To prevent builds on hydra
      hydraPlatforms = [ ];
      # prefer wrapper over the package
      priority = (ark.meta.priority or lib.meta.defaultPriority) - 1;
    };
  }
  ''
    makeWrapper "${ark}/bin/ark" "$out/bin/ark" \
      --prefix "R_HOME" ":" "${R}/lib/R" \
      --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE" \
  ''
