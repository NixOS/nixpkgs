{ lib, stdenv, fetchFromGitHub, callPackage, writeScript, fetchpatch, cmake
, wrapQtAppsHook, qt5, boost, llvmPackages, gcc, jdk, maven, pythonPackages
, coreutils, which, desktop-file-utils, shared-mime-info, imagemagick, libicns
}:

let
  # TODO: remove when version incompatibility issue with python3Packages.jedi is
  # resolved
  parso = pythonPackages.callPackage ./parso.nix { };
  jedi = pythonPackages.callPackage ./jedi.nix { inherit parso; };

  pythonIndexer =
    pythonPackages.callPackage ./python.nix { inherit jedi parso; };
  javaIndexer = callPackage ./java.nix { };

  appPrefixDir = if stdenv.isDarwin then
    "$out/Applications/Sourcetrail.app/Contents"
  else
    "$out/opt/sourcetrail";
  appBinDir =
    if stdenv.isDarwin then "${appPrefixDir}/MacOS" else "${appPrefixDir}/bin";
  appResourceDir = if stdenv.isDarwin then
    "${appPrefixDir}/Resources"
  else
    "${appPrefixDir}/share";

  # Upstream script:
  # https://github.com/CoatiSoftware/Sourcetrail/blob/master/script/update_java_indexer.sh
  installJavaIndexer = writeScript "update_java_indexer.sh" ''
    #!${stdenv.shell}

    cd "$(dirname "$0")/.."
    dst="${appResourceDir}/data/java/lib"

    mkdir -p "$dst"
    cp "${javaIndexer}/target/java-indexer-1.0.jar" "$dst/java-indexer.jar"
    cp -r java_indexer/lib/*.jar "$dst"
  '';

  # Upstream script:
  # https://github.com/CoatiSoftware/Sourcetrail/blob/master/script/download_python_indexer.sh
  installPythonIndexer = writeScript "download_python_indexer.sh" ''
    #!${stdenv.shell}

    mkdir -p ${appResourceDir}/data
    ln -s "${pythonIndexer}/bin" "${appResourceDir}/data/python"
  '';
in stdenv.mkDerivation rec {
  pname = "sourcetrail";
  # NOTE: skip 2020.4.35 https://github.com/CoatiSoftware/Sourcetrail/pull/1136
  version = "2020.2.43";

  src = fetchFromGitHub {
    owner = "CoatiSoftware";
    repo = "Sourcetrail";
    rev = version;
    sha256 = "0jp9y86xzkcxikc1cn4f6gqgg6zdssck08677ldagw25p1zadvzw";
  };

  patches = let
    url = commit:
      "https://github.com/CoatiSoftware/Sourcetrail/commit/${commit}.patch";
  in [
    ./disable-updates.patch
    ./disable-failing-tests.patch # FIXME: 5 test cases failing due to sandbox
    # TODO: remove on next release
    (fetchpatch {
      name = "fix-filecopy.patch";
      url = url "d079d1787c9e5cadcf41a003666dc0746cc1cda0";
      sha256 = "0mixy2a4s16kv2q89k7y4dv21wnv2zd86i4gdwn3xz977y8hf92b";
    })
    (fetchpatch {
      name = "fix-broken-test.patch";
      url = url "85329174bac8a301733100dc4540258f977e2c5a";
      sha256 = "17l4417sbmkrgr6v3fbazlmkzl9774zrpjv2n9zwfrz52y30f7b9";
    })
  ];

  nativeBuildInputs = [
    cmake
    jdk
    wrapQtAppsHook
    desktop-file-utils
    imagemagick
    javaIndexer # the resulting jar file is copied by our install script
  ] ++ lib.optional (stdenv.isDarwin) libicns
    ++ lib.optionals doCheck testBinPath;
  buildInputs = [ boost pythonIndexer shared-mime-info ]
    ++ (with qt5; [ qtbase qtsvg ]) ++ (with llvmPackages; [ libclang llvm ]);
  binPath = [ gcc jdk.jre maven which ];
  testBinPath = binPath ++ [ coreutils ];

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF"
    "-DBUILD_CXX_LANGUAGE_PACKAGE=ON"
    "-DBUILD_JAVA_LANGUAGE_PACKAGE=ON"
    "-DBUILD_PYTHON_LANGUAGE_PACKAGE=ON"
  ] ++ lib.optional stdenv.isLinux
    "-DCMAKE_PREFIX_PATH=${llvmPackages.clang-unwrapped}"
    ++ lib.optional stdenv.isDarwin
    "-DClang_DIR=${llvmPackages.clang-unwrapped}";

  postPatch = let
    major = lib.versions.major version;
    minor = lib.versions.minor version;
    patch = lib.versions.patch version;
  in ''
    # Upstream script obtains it's version from git:
    # https://github.com/CoatiSoftware/Sourcetrail/blob/master/cmake/version.cmake
    cat > cmake/version.cmake <<EOF
    set(GIT_BRANCH "")
    set(GIT_COMMIT_HASH "")
    set(GIT_VERSION_NUMBER "")
    set(VERSION_YEAR "${major}")
    set(VERSION_MINOR "${minor}")
    set(VERSION_COMMIT "${patch}")
    set(BUILD_TYPE "Release")
    set(VERSION_STRING "${major}.${minor}.${patch}")
    EOF

    # Sourcetrail attempts to copy clang headers from the LLVM store path
    substituteInPlace CMakeLists.txt \
      --replace "\''${LLVM_BINARY_DIR}" '${lib.getLib llvmPackages.clang-unwrapped}'

    patchShebangs script
    ln -sf ${installJavaIndexer} script/update_java_indexer.sh
    ln -sf ${installPythonIndexer} script/download_python_indexer.sh
  '';

  # Directory layout for Linux:
  #
  # Sourcetrail doesn't use the usual cmake install() commands and instead uses
  # its own bash script for packaging. Since we're not able to reuse the script,
  # we'll have to roll our own in nixpkgs.
  #
  # Sourcetrail currently assumes one of the following two layouts for the
  # placement of its files:
  #
  # AppImage Layout       Traditional Layout
  # ├── bin/              ├── sourcetrail*
  # │   └── sourcetrail*  └── data/
  # └── share/
  #     └── data/         sourcetrail: application executable
  #                       data: contains assets exlusive to Sourcetrail
  #
  # The AppImage layout is the one currently used by the upstream project for
  # packaging its Linux port. We can't use this layout as-is for nixpkgs,
  # because Sourcetrail treating $out/share/data as its own might lead to
  # conflicts with other packages when linked into a Nix profile.
  #
  # On the other hand, the traditional layout isn't used by the upstream project
  # anymore so there's a risk that it might become unusable at any time in the
  # future. Since it's hard to detect these problems at build time, it's not a
  # good idea to use this layout for packaging in nixpkgs.
  #
  # Considering the problems with the above layouts, we go with the third
  # option, a slight variation of the AppImage layout:
  #
  # nixpkgs
  # ├── bin/
  # │   └── sourcetrail@ (symlink to opt/sourcetrail/bin/sourcetrail)
  # └── opt/sourcetrail/
  #     ├── bin/
  #     │   └── sourcetrail*
  #     └── share/
  #         └── data/
  #
  # Upstream install script:
  # https://github.com/CoatiSoftware/Sourcetrail/blob/master/setup/Linux/createPackages.sh
  installPhase = ''
    runHook preInstall

    mkdir -p ${appResourceDir}
    cp -R ../bin/app/data ${appResourceDir}
    cp -R ../bin/app/user/projects ${appResourceDir}/data/fallback
    rm -r ${appResourceDir}/data/install ${appResourceDir}/data/*_template.xml

    mkdir -p "${appBinDir}"
    cp app/Sourcetrail ${appBinDir}/sourcetrail
    cp app/sourcetrail_indexer ${appBinDir}/sourcetrail_indexer
    wrapQtApp ${appBinDir}/sourcetrail \
      --prefix PATH : ${lib.makeBinPath binPath}

    mkdir -p $out/bin
  '' + lib.optionalString (stdenv.isLinux) ''
    ln -sf ${appBinDir}/sourcetrail $out/bin/sourcetrail

    desktop-file-install --dir=$out/share/applications \
      --set-key Exec --set-value ${appBinDir}/sourcetrail \
      ../setup/Linux/data/sourcetrail.desktop

    mkdir -p $out/share/mime/packages
    cp ../setup/Linux/data/sourcetrail-mime.xml $out/share/mime/packages/

    for size in 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps/
      convert ${appResourceDir}/data/gui/icon/logo_1024_1024.png \
        -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/sourcetrail.png
    done
  '' + lib.optionalString (stdenv.isDarwin) ''
    # change case (some people *might* choose a case sensitive Nix store)
    mv ${appBinDir}/sourcetrail{,.tmp}
    mv ${appBinDir}/{sourcetrail.tmp,Sourcetrail}
    mv ${appBinDir}/sourcetrail_indexer ${appResourceDir}/Sourcetrail_indexer

    ln -sf ${appBinDir}/Sourcetrail $out/bin/sourcetrail

    cp app/bundle_info.plist ${appPrefixDir}/Info.plist

    mkdir -p ${appResourceDir}/icon.iconset
    for size in 16 32 128 256 512; do
      convert ${appResourceDir}/data/gui/icon/logo_1024_1024.png \
        -resize ''${size}x''${size} \
        ${appResourceDir}/icon.iconset/icon_''${size}x''${size}.png
      convert ${appResourceDir}/data/gui/icon/logo_1024_1024.png \
        -resize $(( 2 * size ))x$(( 2 * size )) \
        ${appResourceDir}/icon.iconset/icon_''${size}x''${size}@2x.png
    done
    png2icns ${appResourceDir}/icon.icns \
      ${appResourceDir}/icon.iconset/icon_{16x16,32x32,128x128,256x256,512x512,512x512@2x}.png

    mkdir -p ${appResourceDir}/project.iconset
    for size in 16 32 64 128 256 512; do
      convert ${appResourceDir}/data/gui/icon/project_256_256.png \
        -resize ''${size}x''${size} \
        ${appResourceDir}/project.iconset/icon_''${size}x''${size}.png
      convert ${appResourceDir}/data/gui/icon/project_256_256.png \
        -resize $(( 2 * size ))x$(( 2 * size )) \
        ${appResourceDir}/project.iconset/icon_''${size}x''${size}@2x.png
    done
    png2icns ${appResourceDir}/project.icns \
      ${appResourceDir}/project.iconset/icon_{16x16,32x32,128x128,256x256,512x512,512x512@2x}.png
  '' + ''
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    rm -rf ../bin/app/data/{python,java/lib}
    ln -s $out/opt/sourcetrail/share/data/python ../bin/app/data/python
    ln -s $out/opt/sourcetrail/share/data/java/lib ../bin/app/data/java/lib

    pushd test
    # shorten PATH to prevent build failures
    wrapQtApp ./Sourcetrail_test \
      --set PATH "" \
      --prefix PATH : ${lib.makeBinPath testBinPath} \
      --set MAVEN_OPTS "-Dmaven.repo.local=$TMPDIR/m2repo"
    ./Sourcetrail_test
    popd

    rm ../bin/app/data/{python,java/lib}

    runHook postCheck
  '';

  # This has to be done manually in the installPhase because the actual binary
  # lives in $out/opt/sourcetrail/bin, which isn't covered by wrapQtAppsHook
  dontWrapQtApps = true;

  # FIXME: Some test cases are disabled in the patch phase.
  # FIXME: Tests are disabled on some platforms because of faulty detection
  # logic for libjvm.so. Should work with manual configuration.
  doCheck = !stdenv.isDarwin && stdenv.isx86_64;

  meta = with lib; {
    homepage = "https://www.sourcetrail.com";
    description = "A cross-platform source explorer for C/C++ and Java";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ midchildan ];
  };
}
