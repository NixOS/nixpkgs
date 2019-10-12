{ stdenv, nodePackages_10_x }:

let
  drvName = drv: (builtins.parseDrvName drv).name;
  linkNodeDeps = ({ pkg, deps, name ? "" }:
    let
      targetModule = if name != "" then name else drvName pkg;
    in nodePackages_10_x.${pkg}.override (oldAttrs: {
      postInstall = ''
        mkdir -p $out/lib/node_modules/${targetModule}/node_modules
        ${stdenv.lib.concatStringsSep "\n" (map (dep: ''
          ln -s ${nodePackages_10_x.${dep}}/lib/node_modules/${drvName dep} \
            $out/lib/node_modules/${targetModule}/node_modules/${drvName dep}
        '') deps
        )}
      '';
    })
);
in linkNodeDeps {
 pkg = "@antora/cli";
 name = "@antora/cli";
 deps = [
   "@antora/site-generator-default"
 ];
}
