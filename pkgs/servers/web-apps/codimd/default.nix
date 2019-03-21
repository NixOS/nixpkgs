{ stdenv, pkgs, buildEnv, fetchFromGitHub, makeWrapper
, fetchpatch, nodejs-6_x, phantomjs2, runtimeShell }:
let
  nodePackages = import ./node.nix {
    inherit pkgs;
    system = stdenv.system;
  };

  addPhantomjs = (pkgs:
    map (pkg: pkg.override ( oldAttrs: {
      buildInputs = oldAttrs.buildInputs or [] ++ [ phantomjs2 ];
    })) pkgs);

  drvName = drv: (builtins.parseDrvName drv).name;

  linkNodeDeps = ({ pkg, deps, name ? "" }:
    nodePackages.${pkg}.override (oldAttrs: {
      postInstall = stdenv.lib.concatStringsSep "\n" (map (dep: ''
        ln -s ${nodePackages.${dep}}/lib/node_modules/${drvName dep} \
          $out/lib/node_modules/${if name != "" then name else drvName pkg}/node_modules
      '') deps
      );
    })
  );

  filterNodePackagesToList = (filterPkgs: allPkgs:
    stdenv.lib.mapAttrsToList (_: v: v) (
      stdenv.lib.filterAttrs (n: _:
        ! builtins.elem (drvName n) filterPkgs
      ) allPkgs)
  );

  # add phantomjs to buildInputs
  pkgsWithPhantomjs = (addPhantomjs (map (
    p: nodePackages.${p}
  ) [
    "js-url-^2.3.0"
    "markdown-pdf-^8.0.0"
  ]));

  # link extra dependencies to lib/node_modules
  pkgsWithExtraDeps = map (args:
    linkNodeDeps args ) [
    { pkg = "select2-^3.5.2-browserify";
      deps = [ "url-loader-^0.5.7" ]; }
    { pkg = "js-sequence-diagrams-^1000000.0.6";
      deps = [ "lodash-^4.17.4" ]; }
    { pkg = "ionicons-~2.0.1";
      deps = [ "url-loader-^0.5.7" "file-loader-^0.9.0" ]; }
    { pkg = "font-awesome-^4.7.0";
      deps = [ "url-loader-^0.5.7" "file-loader-^0.9.0" ]; }
    { pkg = "bootstrap-^3.3.7";
      deps = [ "url-loader-^0.5.7" "file-loader-^0.9.0" ]; }
    { pkg = "markdown-it-^8.2.2";
      deps = [ "json-loader-^0.5.4" ]; }
    { pkg = "markdown-it-emoji-^1.3.0";
      deps = [ "json-loader-^0.5.4" ]; }
    { pkg = "raphael-git+https://github.com/dmitrybaranovskiy/raphael";
      deps = [ "eve-^0.5.4" ];
      name = "raphael"; }
  ];

  codemirror = pkgs.callPackage ./CodeMirror { };

  nodeEnv = buildEnv {
    name = "codimd-env";
    paths = pkgsWithPhantomjs ++ pkgsWithExtraDeps ++ [
      codemirror
   ] ++ filterNodePackagesToList [
     "bootstrap"
     "codemirror-git+https://github.com/hackmdio/CodeMirror.git"
     "font-awesome"
     "ionicons"
     "js-sequence-diagrams"
     "js-url"
     "markdown-it"
     "markdown-pdf"
"node-uuid"
     "raphael-git+https://github.com/dmitrybaranovskiy/raphael"
     "select2-browserify"
   ] nodePackages;
  };

  name = "codimd-${version}";
  version = "1.2.0";

  src = stdenv.mkDerivation {
    name = "${name}-src";
    inherit version;

    src = fetchFromGitHub {
      owner = "hackmdio";
      repo = "codimd";
      rev = version;
      sha256 = "003v90g5sxxjv5smxvz6y6bq2ny0xpxhsx2cdgkvj7jla243v48s";
    };

    dontBuild = true;

    installPhase = ''
      mkdir $out
      cp -R . $out
    '';
  };
in
stdenv.mkDerivation rec {
  inherit name version src;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs-6_x ];

  NODE_PATH = "${nodeEnv}/lib/node_modules";

  patches = [
    (fetchpatch { # fixes for configurable paths
      url = "https://patch-diff.githubusercontent.com/raw/hackmdio/codimd/pull/940.patch";
      sha256 = "0w1cvnp3k1n8690gzlrfijisn182i0v8psjs3df394rfx2347xyp";
    })
  ];

  buildPhase = ''
    ln -s ${nodeEnv}/lib/node_modules node_modules
    npm run build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/codimd <<EOF
      #!${runtimeShell}
      ${nodejs-6_x}/bin/node $out/app.js
    EOF
    cp -R {app.js,bin,lib,locales,package.json,public} $out/
  '';

  postFixup = ''
    chmod +x $out/bin/codimd
    wrapProgram $out/bin/codimd \
      --set NODE_PATH "${nodeEnv}/lib/node_modules"
  '';

  passthru = {
    sequelize = pkgs.writeScript "codimd-sequelize" ''
      #!${pkgs.bash}/bin/bash -e
      export NODE_PATH="${nodeEnv}/lib/node_modules"
      exec -a "$0" "${nodeEnv}/lib/node_modules/sequelize-cli/bin/sequelize" "$@"
    '';
  };

  meta = with stdenv.lib; {
    description = "Realtime collaborative markdown notes on all platforms";
    license = licenses.agpl3;
    homepage = https://github.com/hackmdio/codimd;
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.linux;
  };
}
