{
  stdenv,
  lib,
  virtualglLib,
  virtualglLib_i686 ? null,
}:

stdenv.mkDerivation {
  pname = "virtualgl";
  version = lib.getVersion virtualglLib;

  paths = [ virtualglLib ];

  buildCommand =
    ''
      mkdir -p $out/bin
      for i in ${virtualglLib}/bin/* ${virtualglLib}/bin/.vglrun*; do
        ln -s "$i" $out/bin
      done
    ''
    + lib.optionalString (virtualglLib_i686 != null) ''
      ln -sf ${virtualglLib_i686}/bin/.vglrun.vars32 $out/bin
    '';

  meta = {
    platforms = lib.platforms.linux;
    inherit (virtualglLib.meta) license;
  };
}
