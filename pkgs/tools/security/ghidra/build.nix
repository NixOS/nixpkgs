{
  stdenv,
  fetchFromGitHub,
  lib,
  callPackage,
  cmake,
  gradle,
  makeBinaryWrapper,
  openjdk21,
  unzip,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
  xcbuild,
  protobuf,
  ghidra-extensions,
  python3,
  python3Packages,
  zulu8,
}:

let
  pkg_path = "$out/lib/ghidra";
  pname = "ghidra";
  version = "12.1.2";

  isMacArm64 = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  zulu8Include = lib.makeIncludePath [ zulu8 ];
  zulu8DarwinInclude = "${zulu8Include}/darwin";

  releaseName = "NIX";
  distroPrefix = "ghidra_${version}_${releaseName}";
  src = fetchFromGitHub {
    owner = "NationalSecurityAgency";
    repo = "Ghidra";
    rev = "Ghidra_${version}_build";
    hash = "sha256-7/5TR273Sqqr03lE7qpOJUnwTzdr3BzKk+6GhhdOfo8=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 1970-Jan-01
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%b-%d" > $out/SOURCE_DATE_EPOCH
      # 19700101
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y%m%d" > $out/SOURCE_DATE_EPOCH_SHORT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  # https://github.com/NationalSecurityAgency/ghidra/blob/Ghidra_12.1.2_build/Ghidra/Features/FileFormats/build.gradle#L49-L50
  sevenzipjbindingSrc = fetchFromGitHub {
    owner = "borisbrodski";
    repo = "sevenzipjbinding";
    rev = "Release-16.02-2.01";
    hash = "sha256-MtdPBjXUNFc9KwMNMtxmQ1R+cW6dhum73d3KX76GjG0=";
  };

  patches = [
    # Use our own protoc binary instead of the prebuilt one
    ./0001-Use-protobuf-gradle-plugin.patch

    # Override installation directory to allow loading extensions
    ./0002-Load-nix-extensions.patch

    # Remove build dates from output filenames for easier reference
    ./0003-Remove-build-datestamp.patch
  ];

  postPatch = ''
    # Set name of release (eg. PUBLIC, DEV, etc.)
    sed -i -e 's/application\.release\.name=.*/application.release.name=${releaseName}/' Ghidra/application.properties

    # Set build date and git revision
    echo "application.build.date=$(cat SOURCE_DATE_EPOCH)" >> Ghidra/application.properties
    echo "application.build.date.short=$(cat SOURCE_DATE_EPOCH_SHORT)" >> Ghidra/application.properties
    echo "application.revision.ghidra=$(cat COMMIT)" >> Ghidra/application.properties

    # Tells ghidra to use our own protoc binary instead of the prebuilt one.
    tee -a Ghidra/Debug/Debugger-{isf,rmi-trace}/build.gradle <<HERE
    protobuf {
      protoc {
        path = '${protobuf}/bin/protoc'
      }
    }
    HERE
  '';

in
stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    patches
    postPatch
    ;

  # Don't create .orig files if the patch isn't an exact match.
  patchFlags = [
    "--no-backup-if-mismatch"
    "-p1"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ghidra";
      exec = "ghidra";
      icon = "ghidra";
      desktopName = "Ghidra";
      genericName = "Ghidra Software Reverse Engineering Suite";
      categories = [ "Development" ];
      terminal = false;
      startupWMClass = "ghidra-Ghidra";
    })
  ];

  nativeBuildInputs = [
    gradle
    unzip
    makeBinaryWrapper
    copyDesktopItems
    protobuf
    python3
    python3Packages.pip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    desktopToDarwinBundle
  ];

  dontStrip = true;

  __darwinAllowLocalNetworking = true;

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dorg.gradle.java.home=${openjdk21}"
  ]
  ++ lib.optionals isMacArm64 [
    # For some reason I haven't been able to figure out yet, ghidra builds for
    # arm64 seems to build the x64 binaries of the decompiler. These fail to
    # build due to trying to link the x64 object files with arm64 stdc++
    # library, which obviously fails.
    #
    # Those binaries are entirely unnecessary anyways, since we're targeting
    # arm64 build here, so let's exclude them from the build.
    "-x"
    "Decompiler:linkSleighMac_x86_64Executable"
    "-x"
    "Decompiler:linkDecompileMac_x86_64Executable"
  ];

  preBuild = ''
    export JAVA_TOOL_OPTIONS="-Duser.home=$NIX_BUILD_TOP/home"
    gradle -I gradle/support/fetchDependencies.gradle
  '';

  gradleBuildTask = "buildGhidra";

  installPhase = ''
    runHook preInstall

    mkdir -p "${pkg_path}" "$out/share/applications"

    ZIP=build/dist/$(ls build/dist)
    echo $ZIP
    unzip $ZIP -d ${pkg_path}
    f=("${pkg_path}"/*)
    mv "${pkg_path}"/*/* "${pkg_path}"
    rmdir "''${f[@]}"

    ${lib.optionalString isMacArm64 ''
      # sevenzipjbinding-all-platforms jar only ships a macOS x86_64 dylib.
      # Leaving that in the output makes the whole native Ghidra install ask for
      # Rosetta 2 just for 7-Zip support.
      cp -R ${sevenzipjbindingSrc} sevenzipjbinding-src
      chmod -R u+w sevenzipjbinding-src
      substituteInPlace sevenzipjbinding-src/CMakeLists.txt \
        --replace-fail "cmake_policy(SET CMP0026 OLD)" "# cmake_policy(SET CMP0026 OLD)" \
        --replace-fail "GET_TARGET_PROPERTY(SEVENZIP_JBINDING_LIB 7-Zip-JBinding LOCATION)" \
          "SET(SEVENZIP_JBINDING_LIB_FILENAME \"lib7-Zip-JBinding.dylib\")" \
        --replace-fail "GET_FILENAME_COMPONENT(SEVENZIP_JBINDING_LIB_FILENAME \"\''${SEVENZIP_JBINDING_LIB}\" NAME)" ""
      # Call CMake directly so its setup hook does not try to configure Ghidra's
      # Gradle source tree as a CMake project.
      ${lib.getExe cmake} -S sevenzipjbinding-src -B sevenzipjbinding-build \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DJAVA_SYSTEM=Mac \
        -DJAVA_ARCH=arm64 \
        -DJAVA_JDK=${zulu8.home} \
        -DJAVA_INCLUDE_PATH=${zulu8Include} \
        -DJAVA_INCLUDE_PATH2=${zulu8DarwinInclude} \
        -DCMAKE_CXX_FLAGS="-std=gnu++98" \
        -DCMAKE_BUILD_TYPE=Release
      ${lib.getExe cmake} --build sevenzipjbinding-build --parallel "$NIX_BUILD_CORES"

      rm -f "${pkg_path}/Ghidra/Features/FileFormats/lib"/sevenzipjbinding-all-platforms-*.jar
      rm -rf "${pkg_path}/Ghidra/Features/FileFormats/data/sevenzipnativelibs"
      install -Dm444 sevenzipjbinding-build/sevenzipjbinding-Mac-arm64.jar \
        "${pkg_path}/Ghidra/Features/FileFormats/lib/sevenzipjbinding-Mac-arm64.jar"
      substituteInPlace "${pkg_path}/Ghidra/Features/FileFormats/Module.manifest" \
        --replace-fail "lib/sevenzipjbinding-all-platforms-16.02-2.01.jar LGPL 2.1" \
          "lib/sevenzipjbinding-Mac-arm64.jar LGPL 2.1"
      mkdir -p "${pkg_path}/Ghidra/Features/FileFormats/data/sevenzipnativelibs"
      unzip -q sevenzipjbinding-build/sevenzipjbinding-Mac-arm64.jar "Mac-arm64/*" \
        -d "${pkg_path}/Ghidra/Features/FileFormats/data/sevenzipnativelibs"
    ''}

    for f in Ghidra/Framework/Gui/src/main/resources/images/GhidraIcon*.png; do
      res=$(basename "$f" ".png" | cut -d"_" -f3 | cut -c11-)
      install -Dm444 "$f" "$out/share/icons/hicolor/''${res}x''${res}/apps/ghidra.png"
    done;
    # improved macOS icon support
    install -Dm444 Ghidra/Framework/Gui/src/main/resources/images/GhidraIcon64.png $out/share/icons/hicolor/32x32@2/apps/ghidra.png

    runHook postInstall
  '';

  postFixup = ''
    mkdir -p "$out/bin"
    ln -s "${pkg_path}/ghidraRun" "$out/bin/ghidra"
    for bin in ${pkg_path}/support/*; do
      if [[ -x $bin ]]; then
        ln -s "$bin" "$out/bin/ghidra-$(basename $bin)"
      fi
    done
    wrapProgram "${pkg_path}/support/launch.sh" \
      --set-default NIX_GHIDRAHOME "${pkg_path}/Ghidra" \
      --prefix PATH : ${lib.makeBinPath [ openjdk21 ]}
  '';

  passthru = {
    inherit releaseName distroPrefix;
    inherit (ghidra-extensions.override { ghidra = finalAttrs.finalPackage; })
      buildGhidraExtension
      buildGhidraScripts
      ;

    withExtensions = callPackage ./with-extensions.nix { ghidra = finalAttrs.finalPackage; };
  };

  meta = {
    changelog = "https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/Ghidra_${finalAttrs.version}_build/Ghidra/Configurations/Public_Release/src/global/docs/ChangeHistory.html";
    description = "Software reverse engineering (SRE) suite of tools";
    mainProgram = "ghidra";
    homepage = "https://ghidra-sre.org/";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tbaldwin
      roblabla
      vringar
    ];
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
})
