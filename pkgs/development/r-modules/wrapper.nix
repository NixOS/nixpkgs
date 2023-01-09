{ symlinkJoin, R, writeTextDir, makeWrapper, recommendedPackages, packages, rprofileSite, renvironSite }:
let
  rprofile-site = writeTextDir "Rprofile.site" ''
      # Rprofile.site
      # See https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html
      # See https://support.posit.co/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf
      ${rprofileSite}
    '';
  renviron-site = writeTextDir "Renviron.site" ''
      # Renviron.site
      # See https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html
      # See https://support.posit.co/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf
      ${renvironSite}
    '';
  rsetup = symlinkJoin {
    name = "r-initialization";
    paths = [ rprofile-site renviron-site ];
  };
in
symlinkJoin {
  name = R.name + "-wrapper";
  preferLocalBuild = true;
  allowSubstitutes = false;

  buildInputs = [R] ++ recommendedPackages ++ packages;
  paths = [ R ];

  nativeBuildInputs = [makeWrapper];

  postBuild = ''
    cd ${R}/bin
    for exe in *; do
      rm "$out/bin/$exe"

      makeWrapper "${R}/bin/$exe" "$out/bin/$exe" \
        --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
    done

    makeWrapper "${R}/bin/R" "$out/bin/R" \
      --set "R_PROFILE" "${rsetup}/Rprofile.site" \
      --set "R_ENVIRON" "${rsetup}/Renviron.site"
  '';

  # Make the list of recommended R packages accessible to other packages such as rpy2
  passthru = { inherit recommendedPackages; };

    meta = R.meta // {
      # To prevent builds on hydra
      hydraPlatforms = [];
      # prefer wrapper over the package
      priority = (R.meta.priority or 0) - 1;
    };
}
