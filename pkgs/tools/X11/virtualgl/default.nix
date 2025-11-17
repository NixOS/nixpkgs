{
  stdenv,
  lib,
  virtualglLib,
  virtualglLib_i686 ? null,
  makeWrapper,
  vulkan-loader,
  addDriverRunpath,
}:

stdenv.mkDerivation {
  pname = "virtualgl";
  version = lib.getVersion virtualglLib;

  paths = [ virtualglLib ];
  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    for i in ${virtualglLib}/bin/* ${virtualglLib}/bin/.vglrun*; do
      ln -s "$i" $out/bin
    done

    wrapProgram $out/bin/vglrun \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          virtualglLib
          virtualglLib_i686

          addDriverRunpath.driverLink

          # Needed for vulkaninfo to work
          vulkan-loader
        ]
      }"
  ''
  + lib.optionalString (virtualglLib_i686 != null) ''
    ln -sf ${virtualglLib_i686}/bin/.vglrun.vars32 $out/bin
  '';

  meta = {
    platforms = lib.platforms.linux;
    inherit (virtualglLib.meta) license;
  };
}
