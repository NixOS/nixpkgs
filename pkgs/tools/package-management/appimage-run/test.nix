{
  runCommand,
  fetchurl,
  appimage-run,
  glibcLocales,
  file,
  xdg-utils,
}:
let
  # any AppImage usable on cli, really
  sample-appImage = fetchurl {
    url = "https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage";
    sha256 = "04ws94q71bwskmhizhwmaf41ma4wabvfgjgkagr8wf3vakgv866r";
  };
  owdtest = fetchurl {
    url = "https://github.com/NixOS/nixpkgs/files/10099048/owdtest.AppImage.gz";
    sha256 = "sha256-EEp9dxz/+l5XkNaVBFgv5v64sizQILnljRAzwXv/yV8=";
  };
in
runCommand "appimage-run-tests"
  {
    buildInputs = [
      appimage-run
      glibcLocales
      file
      xdg-utils
    ];
    meta.platforms = [ "x86_64-linux" ];
  }
  ''
    export HOME=$(mktemp -d)
    set -x

    # regression test for #101137, must come first
    LANG=fr_FR appimage-run ${sample-appImage} --list ${sample-appImage}

    # regression test for #108426
    cp ${sample-appImage} foo.appImage
    LANG=fr_FR appimage-run ${sample-appImage} --list foo.appImage
    cp ${owdtest} owdtest.AppImage.gz
    gunzip owdtest.AppImage.gz
    appimage-run owdtest.AppImage

    # Verify desktop entry
    XDG_DATA_DIRS="${appimage-run}/share"
    [[ "$(xdg-mime query default application/vnd.appimage)" == '${appimage-run.name}.desktop' ]]

    set +x
    touch $out
  ''
