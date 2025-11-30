{
  lib,
  symlinkJoin,
  R,
  makeWrapper,
  recommendedPackages,
  packages,
}:
symlinkJoin {
  name = R.name + "-wrapper";
  preferLocalBuild = true;

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [ R ] ++ recommendedPackages ++ packages;
  paths = [ R ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    cd ${R}/bin
    for exe in *; do
      rm "$out/bin/$exe"

      makeWrapper "${R}/bin/$exe" "$out/bin/$exe" \
        --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
    done

    ln -s ${R.man} $man
  '';

  # Make the list of recommended R packages accessible to other packages such as rpy2
  passthru = { inherit recommendedPackages; };

  meta = R.meta // {
    # To prevent builds on hydra
    hydraPlatforms = [ ];
    # prefer wrapper over the package
    priority = (R.meta.priority or lib.meta.defaultPriority) - 1;
  };
}
