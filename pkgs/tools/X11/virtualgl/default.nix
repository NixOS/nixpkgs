{ lib, buildEnv
, virtualglLib
, virtualglLib_i686 ? null
}:

buildEnv {
  name = "virtualgl-${lib.getVersion virtualglLib}";

  paths = [ virtualglLib ];

  postBuild = lib.optionalString (virtualglLib_i686 != null) ''
    rm $out/fakelib
    # workaround for #4621
    rm $out/bin
    mkdir $out/bin
    for i in ${virtualglLib}/bin/*; do
      ln -s $i $out/bin
    done
    ln -s ${virtualglLib}/bin/.vglrun.vars64 $out/bin
    ln -s ${virtualglLib_i686}/bin/.vglrun.vars32 $out/bin
  '';
}
