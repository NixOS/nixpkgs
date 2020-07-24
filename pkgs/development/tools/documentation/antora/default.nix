{ stdenv, nodePackages }:

let
  linkNodeDeps = ({ pkg, deps, name ? "" }:
    let
      targetModule = if name != "" then name else stdenv.lib.getName pkg;
    in nodePackages.${pkg}.override (oldAttrs: {
      postInstall = ''
        mkdir -p $out/lib/node_modules/${targetModule}/node_modules
        ${stdenv.lib.concatStringsSep "\n" (map (dep: ''
          ln -s ${nodePackages.${dep}}/lib/node_modules/${stdenv.lib.getName dep} \
            $out/lib/node_modules/${targetModule}/node_modules/${stdenv.lib.getName dep}
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
