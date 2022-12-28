{ pkgs, lib }:
let
  inherit (pkgs) stdenv;

  mkPluginDrv =
    { self
    , plugins
    , drv
    , postInstall ? ""
    , nativeBuildInputs ? [ ]
    , buildInputs ? [ ]
    }:
    let
      env = self.python.withPackages (ps: plugins);
    in
    stdenv.mkDerivation {
      pname = drv.pname + "-with-plugins";

      inherit (drv) src version meta;

      buildInputs = drv.buildInputs ++ drv.propagatedBuildInputs ++ buildInputs;
      nativeBuildInputs = builtins.filter (x: x.name != "python-output-dist-hook") (drv.nativeBuildInputs ++ nativeBuildInputs);

      dontConfigure = true;
      dontBuild = true;
      dontUsePythonRecompileBytecode = true;

      passthru = {
        inherit (drv.passthru) withPlugins;
        inherit plugins;
      };

      # Link bin/ from environment, but only if it's in a plugin
      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin

        for bindir in ${lib.concatStringsSep " " (map (d: "${lib.getBin d}/bin") plugins)}; do
          for bin in $bindir/*; do
            ln -s ${env}/bin/$(basename $bin) $out/bin/
          done
        done

        runHook postInstall
      '';

      inherit postInstall;
    };

in
{

  # Provide the `withPlugins` function
  toPluginAble = self: { drv
                       , finalDrv
                       , postInstall ? ""
                       , nativeBuildInputs ? [ ]
                       , buildInputs ? [ ]
                       }: drv.overridePythonAttrs (old: {
    passthru = old.passthru // {
      withPlugins = pluginFn: mkPluginDrv {
        plugins = [ finalDrv ] ++ pluginFn self;
        inherit self postInstall nativeBuildInputs buildInputs;
        drv = finalDrv;
      };
    };
  });

}
