{ lib, google-cloud-sdk, runCommand, components }:

comps_:

let
  # Remove components which are already installed by default
  filterPreInstalled =
    let
      preInstalledComponents = with components; [ bq bq-nix core core-nix gcloud-deps gcloud gsutil gsutil-nix ];
    in
    builtins.filter (drv: !(builtins.elem drv preInstalledComponents));

  # Recursively build a list of components with their dependencies
  # TODO this could be made faster, it checks the dependencies too many times
  findDepsRecursive = lib.converge
    (drvs: lib.unique (drvs ++ (builtins.concatMap (drv: drv.dependencies) drvs)));

  # Components to install by default
  defaultComponents = with components; [ alpha beta ];

  comps = [ google-cloud-sdk ] ++ filterPreInstalled (findDepsRecursive (defaultComponents ++ comps_));
in
# Components are installed by copying the `google-cloud-sdk` package, along
# with each component, over to a new location, and then patching that location
# with `sed` to ensure the proper paths are used.
# For some reason, this does not work properly with a `symlinkJoin`: the
# `gcloud` binary doesn't seem able to find the installed components.
runCommand "google-cloud-sdk-${google-cloud-sdk.version}"
{
  inherit (google-cloud-sdk) meta;
  inherit comps;
  passAsFile = [ "comps" ];

  doInstallCheck = true;
  disallowedRequisites = [ google-cloud-sdk ];
  installCheckPhase =
    let
      compNames = builtins.map (drv: drv.name) comps_;
    in
    ''
      $out/bin/gcloud components list > component_list.txt
      for comp in ${builtins.toString compNames}; do
        if [ ! grep ... component_list.txt | grep "Not Installed" ]; then
          echo "Failed to install component '$comp'"
          exit 1
        fi
      done
    '';
}
  ''
    mkdir -p $out

    # Install each component
    for comp in $(cat $compsPath); do
      echo "installing component $comp"
      cp -dRf $comp/. $out
      find $out -type d -exec chmod 744 {} +
    done

    # Replace references to the original google-cloud-sdk with this one
    find $out/google-cloud-sdk -type f -exec sed -i -e "s#${google-cloud-sdk}#$out#" {} \;
  ''
