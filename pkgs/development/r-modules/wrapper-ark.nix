{
  lib,
  runCommand,
  R,
  ark,
  jq,
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
      jq
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
    mkdir -p $out/share $out/nix-support

    makeWrapper "${ark}/bin/ark" "$out/bin/ark" \
      --prefix "R_HOME" ":" "${R}/lib/R" \
      --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"

    JUPYTER_PATH=$out/share $out/bin/ark --install > /dev/null

    cat $out/share/kernels/ark/kernel.json \
      | jq --arg R_HOME "${R}/lib/R" '.env["R_HOME"] = $R_HOME' \
      | jq --arg R_LIBS_SITE "$R_LIBS_SITE" '.env["R_LIBS_SITE"] = $R_LIBS_SITE' > kernel.tmp

    mv kernel.tmp $out/share/kernels/ark/kernel.json

    echo "export JUPYTER_PATH=$out/share" > $out/nix-support/setup-hook
  ''
