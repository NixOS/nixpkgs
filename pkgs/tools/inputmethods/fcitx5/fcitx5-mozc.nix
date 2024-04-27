{ bazel
, buildBazelPackage
, fcitx5
, fetchFromGitHub
, gettext
, lib
, mozc
, nixosTests
, pkg-config
, python3
, unzip
}:

buildBazelPackage {
  pname = "fcitx5-mozc";
  version = "unstable-2024-02-09";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "mozc";
    fetchSubmodules = true;
    rev = "c687b82fccd443917359a5c2a7b9b1c5fd3737c9";
    hash = "sha256-lXEW7F7ctI7kNdKEjdeYHbyeF8hf6C5AohoWVIfDbjM=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [
    gettext
    pkg-config
    python3
    unzip
  ];

  buildInputs = [
    mozc
    fcitx5
  ];

  postPatch = ''
    sed -i -e 's|^\(LINUX_MOZC_SERVER_DIR = \).\+|\1"${mozc}/lib/mozc"|' config.bzl
  '';

  inherit bazel;
  removeRulesCC = false;
  dontAddBazelOpts = true;

  bazelFlags = [
    "--config"
    "oss_linux"
    "--compilation_mode"
    "opt"
  ];

  bazelTargets = [
    "unix/fcitx5:fcitx5-mozc.so"
    "unix/icons"
  ];

  fetchAttrs = {
    preInstall = ''
      rm -rf $bazelOut/external/fcitx5
    '';

    sha256 = "sha256-nJbxmF5zbPO7HrFDeI5Ur42ID0M4pqGZoxEF+CBRQ/E=";
  };

  buildAttrs = {
    installPhase = ''
      runHook preInstall

      install -Dm444 ../LICENSE $out/share/licenses/fcitx5-mozc/LICENSE
      install -Dm444 data/installer/credits_en.html $out/share/licenses/fcitx5-mozc/Submodules

      install -Dm555 bazel-bin/unix/fcitx5/fcitx5-mozc.so $out/lib/fcitx5/fcitx5-mozc.so
      install -Dm444 unix/fcitx5/mozc-addon.conf $out/share/fcitx5/addon/mozc.conf
      install -Dm444 unix/fcitx5/mozc.conf $out/share/fcitx5/inputmethod/mozc.conf

      for pofile in unix/fcitx5/po/*.po; do
        filename=$(basename $pofile)
        lang=''${filename/.po/}
        mofile=''${pofile/.po/.mo}
        msgfmt $pofile -o $mofile
        install -Dm444 $mofile $out/share/locale/$lang/LC_MESSAGES/fcitx5-mozc.mo
      done

      msgfmt --xml -d unix/fcitx5/po/ --template unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml.in -o unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml
      install -Dm444 unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml $out/share/metainfo/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml

      cd bazel-bin/unix

      unzip -o icons.zip

      # These are relative symlinks, they will always resolve to files within $out

      install -Dm444 mozc.png $out/share/icons/hicolor/128x128/apps/org.fcitx.Fcitx5.fcitx-mozc.png
      ln -s org.fcitx.Fcitx5.fcitx-mozc.png $out/share/icons/hicolor/128x128/apps/fcitx-mozc.png

      rm {mozc,dictionary,properties,tool}.svg
      for svg in *.svg outlined/*.svg; do
        name=$(basename -- ''${svg//_/-})
        path=$out/share/icons/hicolor/scalable/apps
        prefix=org.fcitx.Fcitx5.fcitx-mozc

        install -Dm444 $svg $path/$prefix-$name
        ln -s $prefix-$name $path/fcitx-mozc-$name
      done

      runHook postInstall
    '';
  };

  passthru.tests = {
    inherit (nixosTests) fcitx5;
  };

  meta = with lib; {
    description = "Mozc - a Japanese Input Method Editor designed for multi-platform";
    homepage = "https://github.com/fcitx/mozc";
    license = with licenses; [
      asl20 # abseil-cpp
      bsd3 # mozc, breakpad, gtest, gyp, japanese-usage-dictionary, protobuf
      mit # wil
      naist-2003 # IPAdic
      publicDomain # src/data/test/stress_test, Okinawa dictionary
      unicode-30 # src/data/unicode, breakpad
    ];
    maintainers = with maintainers; [ berberman govanify ];
    platforms = platforms.linux;
  };
}
