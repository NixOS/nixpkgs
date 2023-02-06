{ stdenv
, fetchzip
, fetchurl
, fetchFromGitHub
, lib
, gradle
, perl
, makeWrapper
, openjdk17
, unzip
, makeDesktopItem
, autoPatchelfHook
, icoutils
, xcbuild
, protobuf3_17
, libredirect
, symlinkJoin
, callPackage
}:

let
  pkg_path = "$out/lib/ghidra";
  pname = "ghidra";
  version = "10.2.2";

  src = fetchFromGitHub {
    owner = "NationalSecurityAgency";
    repo = "Ghidra";
    rev = "Ghidra_${version}_build";
    sha256 = "sha256-AiyY6mGM+jHu9n39t/cYj+I5CE+a3vA4P0THNEFoZrk=";
  };

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
    path = '${protobuf3_17}/bin/protoc'
  }
}
HERE
  '';

  # Adds a gradle step that downloads all the dependencies to the gradle cache.
  addResolveStep = ''
    cat >>build.gradle <<HERE
task resolveDependencies {
  doLast {
    project.rootProject.allprojects.each { subProject ->
      subProject.buildscript.configurations.each { configuration ->
        resolveConfiguration(subProject, configuration, "buildscript config \''${configuration.name}")
      }
      subProject.configurations.each { configuration ->
        resolveConfiguration(subProject, configuration, "config \''${configuration.name}")
      }
    }
  }
}
void resolveConfiguration(subProject, configuration, name) {
  if (configuration.canBeResolved) {
    logger.info("Resolving project {} {}", subProject.name, name)
    configuration.resolve()
  }
}
HERE
  '';

  # fake build to pre-download deps into fixed-output derivation
  # Taken from mindustry derivation.
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version src;

    patches = [ ./0001-Use-protobuf-gradle-plugin.patch ];
    postPatch = fixProtoc + addResolveStep;

    nativeBuildInputs = [ gradle perl ] ++ lib.optional stdenv.isDarwin xcbuild;
    buildPhase = ''
      export HOME="$NIX_BUILD_TOP/home"
      mkdir -p "$HOME"
      export JAVA_TOOL_OPTIONS="-Duser.home='$HOME'"
      export GRADLE_USER_HOME="$HOME/.gradle"

      # First, fetch the static dependencies.
      gradle --no-daemon --info -Dorg.gradle.java.home=${openjdk17} -I gradle/support/fetchDependencies.gradle init

      # Then, fetch the maven dependencies.
      gradle --no-daemon --info -Dorg.gradle.java.home=${openjdk17} resolveDependencies
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/maven/$x/$3/$4/$5" #e' \
        | sh
      cp -r dependencies $out/dependencies
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-Z4RS3IzDP8V3SrrwOuX/hTlX7fs3woIhR8GPK/tFAzs=";
  };

in

let ghidra =

stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    gradle unzip makeWrapper icoutils
  ] ++ lib.optional stdenv.isDarwin xcbuild;

  dontStrip = true;

  patches = [ ./0001-Use-protobuf-gradle-plugin.patch ];
  postPatch = fixProtoc;

  buildPhase = ''
    export HOME="$NIX_BUILD_TOP/home"
    mkdir -p "$HOME"
    export JAVA_TOOL_OPTIONS="-Duser.home='$HOME'"

    ln -s ${deps}/dependencies dependencies

    sed -i "s#mavenLocal()#mavenLocal(); maven { url '${deps}/maven' }#g" build.gradle

    gradle --offline --no-daemon --info -Dorg.gradle.java.home=${openjdk17} buildGhidra
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

  passthru = rec {
    # TODO better? https://github.com/NixOS/nixpkgs/issues/59344
    # WONTFIX: symlinkJoin does not replace existing files
    # https://discourse.nixos.org/t/overriding-a-package-without-rebuilding-it/13898
    /*
    withPatches = patches: if patches == [] then ghidra else symlinkJoin {
      name = ghidra.name + "-with-patches";
      paths = [ ghidra ] ++ patches;
    };
    */
    # example use:
    # nix-build -E 'with import ./. {}; ghidra.withPatches (p: with p; [ scale-by-2 ])'
    withPatches = getPatches: let selectedPatches = getPatches patches; in if selectedPatches == [] then ghidra else stdenv.mkDerivation {
      # this works similar to patches in stdenv.mkDerivation
      name = ghidra.name + "-with-patches";
      #paths = [ ghidra ] ++ patches;
      # TODO? use eval for patchPhase etc
      buildCommand = ''
        replaceSymlinkWithFile() {
          if [ -L "$1" ]; then
            cp --remove-destination "$(readlink "$1")" "$1"
          fi
        }

        echo "adding base files"
        # this breaks relative symlinks
        #cp -r -s --no-preserve=mode ${ghidra} $out

        # TODO? make this faster https://github.com/NixOS/nixpkgs/pull/214710
        t1=$(date +%s.%N)
        pushd ${ghidra} >/dev/null
        if false; then
        # adding base files done after 62.4797 seconds
        while read file; do
          d="$(dirname "$file")"
          if ! [ -d "$out/$d" ]; then mkdir -p "$out/$d"; fi
          if [ -L "$file" ]; then
            cp -P --no-preserve=mode "$file" "$out/$d/"
          else
            cp -s --no-preserve=mode "${ghidra}/$file" "$out/$d/"
          fi
        done < <(find . -not -type d -printf "%P\n")
        else
        # adding base files done after 57.7547 seconds
        while read file_type; do
          file=''${file_type:0: -1}
          type=''${file_type: -1}
          case $type in
            d)
              mkdir -p "$out/$file"
              ;;
            l)
              cp -P --no-preserve=mode "$file" "$out/$file"
              ;;
            *)
              d="$(dirname "$file")"
              cp -s --no-preserve=mode "${ghidra}/$file" "$out/$d/"
          esac
        done < <(find . -printf "%P%y\n")
        fi
        popd >/dev/null
        t2=$(date +%s.%N)
        dt=$(echo $t1 $t2 | awk '{print $2 - $1}')
        echo adding base files done after $dt seconds

        echo "fixing wrappers"
        replaceSymlinkWithFile $out/lib/ghidra/ghidraRun
        for wrapper in lib/ghidra/support/launch.sh; do
          echo fixing wrapper: $out/$wrapper
          replaceSymlinkWithFile $out/$wrapper
          substituteInPlace $out/$wrapper \
            --replace ${ghidra} $out
        done

        echo "applying patches"
        ${lib.concatStringsSep "\n" (map (patch: ''
          echo "applying patch: ${if builtins.isAttrs patch then patch.name else patch.outPath}"
          set -x # trace
          # subshell
          #( # FIXME subshell does not catch errors. "set -e" does not help
            set -e
            ${patch.patchPhase or ''
              ${if (patch.prePatch or "") == "" then "" else ''
              echo "running prePatch hook"
              ${patch.prePatch}
              ''}
              ${if builtins.isAttrs patch then "" else ''
              echo "adding patch files"
              while read file; do
                if [ -e "$out/$file" ]; then
                  echo "replacing file: $file"
                  rm "$out/$file"
                else
                  echo "adding file: $file"
                  d="$(dirname "$file")"
                  if ! [ -d "$out/$d" ]; then mkdir -p "$out/$d"; fi
                fi
                cp -s --no-preserve=mode --preserve=links "${patch}/$file" "$out/$file"
              done < <(cd ${patch}; find . -not -type d -printf "%P\n")
              ''}
              ${if (patch.postPatch or "") == "" then "" else ''
              echo "running postPatch hook"
              ${patch.postPatch}
              ''}
            ''}
          #) # subshell
          set +x # trace off
        '') selectedPatches)}
      '';
    };
    patches = {
      scale-by-2 = callPackage ./patches/scale-by-2 { };
      # patch is broken, just a demo how to add files
      #flatlaf-dark-theme = callPackage ./patches/flatlaf-dark-theme { };
      # patch is broken, just a demo how to patch files
      #use-vmargs-env = callPackage ./patches/use-vmargs-env { };
    };
  };

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
  };

}

; in ghidra
