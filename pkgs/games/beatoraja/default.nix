{
  lib,
  pkgs,
  symlinkJoin,
  jdk,
  jre,
  gradle,
  makeWrapper,
}:

let
  mkBeatorajaPackage =
    path:
    let
      beatorajaPackages = lib.makeExtensible (self: {
        callPackage = lib.callPackageWith (pkgs // self);

        jdk = jdk.override { enableJavaFX = true; };
        jre = jre.override { enableJavaFX = true; };
        gradle = gradle.override { java = self.jdk; };

        jportaudio = self.callPackage ./jportaudio { };
        launcher = self.callPackage ./launcher { };

        beatoraja = self.callPackage path { };

        # ir
        bokutachi-ir = self.callPackage ./bokutachi-ir { };
        minir = self.callPackage ./minir { };

        # skin
        brook = self.callPackage ./brook { };
        groundbreaking = self.callPackage ./groundbreaking { };
        modernchic = self.callPackage ./modernchic { };
      });

      wrapper =
        packagesFun:
        symlinkJoin {
          inherit (beatorajaPackages.beatoraja) pname version;

          paths = [
            beatorajaPackages.beatoraja
            beatorajaPackages.launcher
          ]
          ++ packagesFun beatorajaPackages;

          nativeBuildInputs = [ makeWrapper ];

          postBuild = ''
            wrapProgram $out/bin/beatoraja --set BEATORAJA_HOME $out/share/beatoraja
          '';

          passthru = beatorajaPackages.beatoraja.passthru or { } // {
            unwrapped = beatorajaPackages.beatoraja;
            pkgs = beatorajaPackages;
            withPackages = wrapper;
          };

          meta = beatorajaPackages.beatoraja.meta // {
            inherit (beatorajaPackages.launcher.meta) mainProgram;
          };
        };
    in
    wrapper (_: [ ]);

in
{
  beatoraja = mkBeatorajaPackage ./beatoraja;
  beatoraja-bin = mkBeatorajaPackage ./beatoraja-bin;
  lr2oraja = mkBeatorajaPackage ./lr2oraja;
  lr2oraja-endlessdream = mkBeatorajaPackage ./lr2oraja-endlessdream;
}
