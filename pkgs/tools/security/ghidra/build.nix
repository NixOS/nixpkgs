{
  stdenv,
  fetchFromGitHub,
  lib,
  callPackage,
  gradle_8,
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
}:

let
  pkg_path = "$out/lib/ghidra";
  pname = "ghidra";
  version = "11.4.2";

  isMacArm64 = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;

  releaseName = "NIX";
  distroPrefix = "ghidra_${version}_${releaseName}";
  src = fetchFromGitHub {
    owner = "NationalSecurityAgency";
    repo = "Ghidra";
    rev = "Ghidra_${version}_build";
    hash = "sha256-/veSp2WuGOF0cYwUC4QFJD6kaMae5NuKrQ5Au4LjDe8=";
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

  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;

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
    ln -s "${pkg_path}/support/analyzeHeadless" "$out/bin/ghidra-analyzeHeadless"
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

  meta = with lib; {
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
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [
      roblabla
      vringar
    ];
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
})
