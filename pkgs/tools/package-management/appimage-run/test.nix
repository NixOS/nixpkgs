{ runCommand, fetchurl, appimage-run, glibcLocales, file }:
let
  # any AppImage usable on cli, really
  sample-appImage = fetchurl {
    url = "https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage";
    sha256 =  "04ws94q71bwskmhizhwmaf41ma4wabvfgjgkagr8wf3vakgv866r";
  };
in
  runCommand "appimage-run-tests" {
    buildInputs = [ appimage-run glibcLocales file ];
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
    set +x
    touch $out
  ''

