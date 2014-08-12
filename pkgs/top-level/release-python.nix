/*
   test for example like this
   $ nix-build pkgs/top-level/release-python.nix
*/

{ nixpkgs ? { outPath = (import ./all-packages.nix {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" "i686-linux" "x86_64-darwin" "x86_64-freebsd" "i686-freebsd" ]
}:

with import ./release-lib.nix {inherit supportedSystems; };

let
  jobsForDerivations = attrset: pkgs.lib.attrsets.listToAttrs
    (map
      (name: { inherit name;
               value = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };})
      (builtins.attrNames
        (pkgs.lib.attrsets.filterAttrs
          (n: v: (v.type or null) == "derivation")
          attrset)));


  jobs =
    {

   # } // (mapTestOn ((packagesWithMetaPlatform pkgs) // rec {

    } // (mapTestOn rec {

  offlineimap = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };  
  pycairo = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pycrypto = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pycups = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pydb = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyexiv2 = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pygame = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pygobject = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pygtk = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyGtkGlade = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyIRCt = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyMAILt = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyopenssl = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyqt4 = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyrex = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyrex096 = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyside = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pysideApiextractor = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pysideGeneratorrunner = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pysideShiboken = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pysideTools = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pystringtemplate = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  python26 = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  python27 = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  python26Full = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  python27Full = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  python26Packages = jobsForDerivations pkgs.python26Packages;
  python27Packages = jobsForDerivations pkgs.python27Packages;
  python3 = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pythonDBus = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pythonIRClib = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pythonmagick = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pythonSexy = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyx = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
  pyxml = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };
});

in jobs
