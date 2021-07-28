{ makeScope, libsForQt5, lxqt }:

let
  packages = self: with self; {

    # Libs
    libcprime = callPackage ../misc/cubocore/libcprime {};

    libcsys = callPackage ../misc/cubocore/libcsys {};

    # Apps
    coreaction = callPackage ../misc/cubocore/coreaction {};

    corearchiver = callPackage ../misc/cubocore/corearchiver {};

    corefm = callPackage ../misc/cubocore/corefm {};

    coregarage = callPackage ../misc/cubocore/coregarage {};

    corehunt = callPackage ../misc/cubocore/corehunt {};

    coreimage = callPackage ../misc/cubocore/coreimage {};

    coreinfo = callPackage ../misc/cubocore/coreinfo {};

    corekeyboard = callPackage ../misc/cubocore/corekeyboard {};

    corepad = callPackage ../misc/cubocore/corepad {};

    corepaint = callPackage ../misc/cubocore/corepaint {};

    corepdf = callPackage ../misc/cubocore/corepdf {};

    corepins = callPackage ../misc/cubocore/corepins {};

    corerenamer = callPackage ../misc/cubocore/corerenamer {};

    coreshot = callPackage ../misc/cubocore/coreshot {};

    corestats = callPackage ../misc/cubocore/corestats {};

    corestuff = callPackage ../misc/cubocore/corestuff {};

    coreterminal = callPackage ../misc/cubocore/coreterminal {
        inherit (lxqt) qtermwidget;
    };

    coretime = callPackage ../misc/cubocore/coretime {};

    coretoppings = callPackage ../misc/cubocore/coretoppings {};

    coreuniverse = callPackage ../misc/cubocore/coreuniverse {};
  };
in makeScope libsForQt5.newScope packages
