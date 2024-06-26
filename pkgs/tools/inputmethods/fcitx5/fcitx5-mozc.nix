{
  lib,
  clangStdenv,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  python3Packages,
  ninja,
  pkg-config,
  protobuf,
  zinnia,
  qt5,
  fcitx5,
  jsoncpp,
  gtest,
  which,
  gtk2,
  unzip,
  abseil-cpp,
  breakpad,
  nixosTests,
}:
let
  inherit (python3Packages) python gyp six;
  utdic = fetchurl {
    url = "https://osdn.net/downloads/users/39/39056/mozcdic-ut-20220904.tar.bz2";
    sha256 = "sha256-pmLBCcw2Zsirzl1PjYkviRIZoyfUz5rpESeABDxuhtU=";
  };
  japanese_usage_dictionary = fetchFromGitHub {
    owner = "hiroyuki-komatsu";
    repo = "japanese-usage-dictionary";
    rev = "e5b3425575734c323e1d947009dd74709437b684";
    sha256 = "0pyrpz9c8nxccwpgyr36w314mi8h132cis8ijvlqmmhqxwsi30hm";
  };
  zipcode_rel = "202011";
  jigyosyo = fetchurl {
    url = "https://osdn.net/projects/ponsfoot-aur/storage/mozc/jigyosyo-${zipcode_rel}.zip";
    sha256 = "j7MkNtd4+QTi91EreVig4/OV0o5y1+KIjEJBEmLK/mY=";
  };
  x-ken-all = fetchurl {
    url = "https://osdn.net/projects/ponsfoot-aur/storage/mozc/x-ken-all-${zipcode_rel}.zip";
    sha256 = "ExS0Cg3rs0I9IOVbZHLt8UEfk8/LmY9oAHPVVlYuTPw=";
  };

in
clangStdenv.mkDerivation {
  pname = "fcitx5-mozc";
  version = "2.26.4220.102";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "mozc";
    rev = "1882e33b61673b66d63277f82b4c80ae4e506c10";
    sha256 = "R+w0slVFpqtt7PIr1pyupJjRoQsABVZiMdZ9fKGKAqw=";
  };

  nativeBuildInputs = [
    gyp
    ninja
    python
    pkg-config
    qt5.wrapQtAppsHook
    six
    which
    unzip
  ];

  buildInputs = [
    protobuf
    zinnia
    qt5.qtbase
    fcitx5
    abseil-cpp
    jsoncpp
    gtest
    gtk2
  ];

  patches = [
    # Support linking system abseil-cpp
    (fetchpatch {
      url = "https://salsa.debian.org/debian/mozc/-/raw/debian/sid/debian/patches/0007-Update-src-base-absl.gyp.patch";
      sha256 = "UiS0UScDKyAusXOhc7Bg8dF8ARQQiVTylEhAOxqaZt8=";
    })

  ];

  postUnpack = ''
    unzip ${x-ken-all} -d $sourceRoot/src/
    unzip ${jigyosyo} -d $sourceRoot/src/
    mkdir $TMPDIR/unpack
    tar xf ${utdic} -C $TMPDIR/unpack
    cat $TMPDIR/unpack/mozcdic-ut-20220904/mozcdic-ut-20220904.txt >> $sourceRoot/src/data/dictionary_oss/dictionary00.txt

    rmdir $sourceRoot/src/third_party/breakpad/
    ln -s ${breakpad} $sourceRoot/src/third_party/breakpad
    rmdir $sourceRoot/src/third_party/gtest/
    ln -s ${gtest} $sourceRoot/src/third_party/gtest
    rmdir $sourceRoot/src/third_party/gyp/
    ln -s ${gyp} $sourceRoot/src/third_party/gyp
    rmdir $sourceRoot/src/third_party/japanese_usage_dictionary/
    ln -s ${japanese_usage_dictionary} $sourceRoot/src/third_party/japanese_usage_dictionary
  '';

  # Copied from https://github.com/archlinux/svntogit-community/blob/packages/fcitx5-mozc/trunk/PKGBUILD
  configurePhase = ''
    cd src
    export GYP_DEFINES="document_dir=$out/share/doc/mozc use_libzinnia=1 use_libprotobuf=1 use_libabseil=1"

    # disable fcitx4
    rm unix/fcitx/fcitx.gyp

    # gen zip code seed
    PYTHONPATH="$PWD:$PYTHONPATH" python dictionary/gen_zip_code_seed.py --zip_code="x-ken-all.csv" --jigyosyo="JIGYOSYO.CSV" >> data/dictionary_oss/dictionary09.txt

    # use libstdc++ instead of libc++
    sed "/stdlib=libc++/d;/-lc++/d" -i gyp/common.gypi

    # run gyp
    python build_mozc.py gyp --gypdir=${gyp}/bin --server_dir=$out/lib/mozc
  '';

  buildPhase = ''
    runHook preBuild

    python build_mozc.py build -c Release \
      server/server.gyp:mozc_server \
      gui/gui.gyp:mozc_tool \
      unix/fcitx5/fcitx5.gyp:fcitx5-mozc

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    export PREFIX=$out
    export _bldtype=Release
    ../scripts/install_server
    install -d $out/share/licenses/fcitx5-mozc
    head -n 29 server/mozc_server.cc > $out/share/licenses/fcitx5-mozc/LICENSE
    install -m644 data/installer/*.html $out/share/licenses/fcitx5-mozc/
    install -d $out/share/fcitx5/addon
    install -d $out/share/fcitx5/inputmethod
    install -d $out/lib/fcitx5
    ../scripts/install_fcitx5

    runHook postInstall
  '';

  preFixup = ''
    wrapQtApp $out/lib/mozc/mozc_tool
  '';

  passthru.tests = {
    inherit (nixosTests) fcitx5;
  };

  meta = with lib; {
    description = "Fcitx5 Module of A Japanese Input Method for Chromium OS, Windows, Mac and Linux (the Open Source Edition of Google Japanese Input)";
    homepage = "https://github.com/fcitx/mozc";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      berberman
      govanify
    ];
    platforms = platforms.linux;
  };
}
