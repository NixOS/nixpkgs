{ stdenv
, fetchFromGitHub
, lib
, gradle_7
, makeWrapper
, openjdk17
, unzip
, makeDesktopItem
, icoutils
, xcbuild
, protobuf
}:

let
  pkg_path = "$out/lib/ghidra";
  pname = "ghidra";
  version = "10.3";

  src = fetchFromGitHub {
    owner = "NationalSecurityAgency";
    repo = "Ghidra";
    rev = "Ghidra_${version}_build";
    hash = "sha256-v3XP+4fwjPzt/OOxX27L0twXw8T1Y94hgP4A5Ukol5I=";
  };

  gradle = gradle_7;

  desktopItem = makeDesktopItem {
    name = "ghidra";
    exec = "ghidra";
    icon = "ghidra";
    desktopName = "Ghidra";
    genericName = "Ghidra Software Reverse Engineering Suite";
    categories = [ "Development" ];
  };

  # postPatch scripts.
  # Tells ghidra to use our own protoc binary instead of the prebuilt one.
  fixProtoc = ''
    cat >>Ghidra/Debug/Debugger-gadp/build.gradle <<HERE
protobuf {
  protoc {
    path = '${protobuf}/bin/protoc'
  }
}
HERE
    cat >>Ghidra/Debug/Debugger-isf/build.gradle <<HERE
protobuf {
  protoc {
    path = '${protobuf}/bin/protoc'
  }
}
HERE
  '';

in gradle.buildPackage {
  inherit pname version src;

  gradleOpts = {
    depsHash = "sha256-Tj3WznDcJxp6P6lLS1VUikcnSD3Vn4c+dRoIarS+Au0=";
    lockfileTree = ./lockfiles;
    flags = [
      "-Dorg.gradle.java.home=${openjdk17}"
    ];
    buildSubcommand = "buildGhidra";
    depsAttrs = {
      preBuild = ''
        ''${gradle[@]} -I gradle/support/fetchDependencies.gradle init
      '';
      postInstall = ''
        cp -r dependencies $out/dependencies
      '';
    };
  };

  nativeBuildInputs = [
    unzip makeWrapper icoutils
  ] ++ lib.optional stdenv.isDarwin xcbuild;

  dontStrip = true;

  patches = [ ./0001-Use-protobuf-gradle-plugin.patch ];
  postPatch = fixProtoc + ''
    export HOME="$NIX_BUILD_TOP/home"
    mkdir -p "$HOME"
    export JAVA_TOOL_OPTIONS="-Duser.home='$HOME'"
    export GRADLE_USER_HOME="$HOME/.gradle"
  '';

  preBuild = ''
    ln -s $deps/dependencies dependencies
  '';

  installPhase = ''
    mkdir -p "${pkg_path}" "$out/share/applications"

    ZIP=build/dist/$(ls build/dist)
    echo $ZIP
    unzip $ZIP -d ${pkg_path}
    f=("${pkg_path}"/*)
    mv "${pkg_path}"/*/* "${pkg_path}"
    rmdir "''${f[@]}"

    ln -s ${desktopItem}/share/applications/* $out/share/applications

    icotool -x "Ghidra/RuntimeScripts/Windows/support/ghidra.ico"
    rm ghidra_4_40x40x32.png
    for f in ghidra_*.png; do
      res=$(basename "$f" ".png" | cut -d"_" -f3 | cut -d"x" -f1-2)
      mkdir -pv "$out/share/icons/hicolor/$res/apps"
      mv "$f" "$out/share/icons/hicolor/$res/apps/ghidra.png"
    done;
  '';

  postFixup = ''
    mkdir -p "$out/bin"
    ln -s "${pkg_path}/ghidraRun" "$out/bin/ghidra"
    wrapProgram "${pkg_path}/support/launch.sh" \
      --prefix PATH : ${lib.makeBinPath [ openjdk17 ]}
  '';

  meta = with lib; {
    description = "A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission";
    homepage = "https://ghidra-sre.org/";
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ roblabla ];
    broken = stdenv.isDarwin;
  };

}
