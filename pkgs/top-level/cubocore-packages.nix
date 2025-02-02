{ newScope, lxqt, lib, libsForQt5 }:

let
  packages = self: with self; {

    # Libs
    libcprime = libsForQt5.callPackage ../applications/misc/cubocore-packages/libcprime { };

    libcsys = libsForQt5.callPackage ../applications/misc/cubocore-packages/libcsys { };

    # Apps
    coreaction = libsForQt5.callPackage ../applications/misc/cubocore-packages/coreaction {
      inherit libcprime libcsys;
    };

    corearchiver = libsForQt5.callPackage ../applications/misc/cubocore-packages/corearchiver {
      inherit libcprime libcsys;
    };

    corefm = libsForQt5.callPackage ../applications/misc/cubocore-packages/corefm {
      inherit libcprime libcsys;
    };

    coregarage = libsForQt5.callPackage ../applications/misc/cubocore-packages/coregarage {
      inherit libcprime libcsys;
    };

    corehunt = libsForQt5.callPackage ../applications/misc/cubocore-packages/corehunt {
      inherit libcprime libcsys;
    };

    coreimage = libsForQt5.callPackage ../applications/misc/cubocore-packages/coreimage {
      inherit libcprime libcsys;
    };

    coreinfo = libsForQt5.callPackage ../applications/misc/cubocore-packages/coreinfo {
      inherit libcprime libcsys;
    };

    corekeyboard = libsForQt5.callPackage ../applications/misc/cubocore-packages/corekeyboard {
      inherit libcprime libcsys;
    };

    corepad = libsForQt5.callPackage ../applications/misc/cubocore-packages/corepad {
      inherit libcprime libcsys;
    };

    corepaint = libsForQt5.callPackage ../applications/misc/cubocore-packages/corepaint {
      inherit libcprime libcsys;
    };

    corepdf = libsForQt5.callPackage ../applications/misc/cubocore-packages/corepdf {
      inherit libcprime libcsys;
    };

    corepins = libsForQt5.callPackage ../applications/misc/cubocore-packages/corepins {
      inherit libcprime libcsys;
    };

    corerenamer = libsForQt5.callPackage ../applications/misc/cubocore-packages/corerenamer {
      inherit libcprime libcsys;
    };

    coreshot = libsForQt5.callPackage ../applications/misc/cubocore-packages/coreshot {
      inherit libcprime libcsys;
    };

    corestats = libsForQt5.callPackage ../applications/misc/cubocore-packages/corestats {
      inherit libcprime libcsys;
    };

    corestuff = libsForQt5.callPackage ../applications/misc/cubocore-packages/corestuff {
      inherit libcprime libcsys;
    };

    coreterminal = libsForQt5.callPackage ../applications/misc/cubocore-packages/coreterminal {
      qtermwidget = lxqt.qtermwidget_1_4;
      inherit libcprime libcsys;
    };

    coretime = libsForQt5.callPackage ../applications/misc/cubocore-packages/coretime {
      inherit libcprime libcsys;
    };

    coretoppings = libsForQt5.callPackage ../applications/misc/cubocore-packages/coretoppings {
      inherit libcprime libcsys;
    };

    coreuniverse = libsForQt5.callPackage ../applications/misc/cubocore-packages/coreuniverse {
      inherit libcprime libcsys;
    };
  };
in
lib.makeScope newScope packages
