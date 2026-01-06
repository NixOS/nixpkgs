{
  lib,
  newScope,
  lxqt,
}:

let
  packages =
    self: with self; {

      # Libs
      libcprime = callPackage ../applications/misc/cubocore-packages/libcprime { };

      libcsys = callPackage ../applications/misc/cubocore-packages/libcsys { };

      # Apps
      coreaction = callPackage ../applications/misc/cubocore-packages/coreaction {
        inherit libcprime libcsys;
      };

      corearchiver = callPackage ../applications/misc/cubocore-packages/corearchiver {
        inherit libcprime libcsys;
      };

      corefm = callPackage ../applications/misc/cubocore-packages/corefm {
        inherit libcprime libcsys;
      };

      coregarage = callPackage ../applications/misc/cubocore-packages/coregarage {
        inherit libcprime libcsys;
      };

      corehunt = callPackage ../applications/misc/cubocore-packages/corehunt {
        inherit libcprime libcsys;
      };

      coreimage = callPackage ../applications/misc/cubocore-packages/coreimage {
        inherit libcprime libcsys;
      };

      coreinfo = callPackage ../applications/misc/cubocore-packages/coreinfo {
        inherit libcprime libcsys;
      };

      corekeyboard = callPackage ../applications/misc/cubocore-packages/corekeyboard {
        inherit libcprime libcsys;
      };

      corepad = callPackage ../applications/misc/cubocore-packages/corepad {
        inherit libcprime libcsys;
      };

      corepaint = callPackage ../applications/misc/cubocore-packages/corepaint {
        inherit libcprime libcsys;
      };

      corepdf = callPackage ../applications/misc/cubocore-packages/corepdf {
        inherit libcprime libcsys;
      };

      corepins = callPackage ../applications/misc/cubocore-packages/corepins {
        inherit libcprime libcsys;
      };

      corerenamer = callPackage ../applications/misc/cubocore-packages/corerenamer {
        inherit libcprime libcsys;
      };

      coreshot = callPackage ../applications/misc/cubocore-packages/coreshot {
        inherit libcprime libcsys;
      };

      corestats = callPackage ../applications/misc/cubocore-packages/corestats {
        inherit libcprime libcsys;
      };

      corestuff = callPackage ../applications/misc/cubocore-packages/corestuff {
        inherit libcprime libcsys;
      };

      coreterminal = callPackage ../applications/misc/cubocore-packages/coreterminal {
        qtermwidget = lxqt.qtermwidget;
        inherit libcprime libcsys;
      };

      coretime = callPackage ../applications/misc/cubocore-packages/coretime {
        inherit libcprime libcsys;
      };

      coretoppings = callPackage ../applications/misc/cubocore-packages/coretoppings {
        inherit libcprime libcsys;
      };

      coreuniverse = callPackage ../applications/misc/cubocore-packages/coreuniverse {
        inherit libcprime libcsys;
      };
    };
in
lib.makeScope newScope packages
