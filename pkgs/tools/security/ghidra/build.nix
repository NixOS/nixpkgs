{ stdenv
, fetchzip
, fetchurl
, fetchFromGitHub
, lib
, gradle
, perl
, makeWrapper
, openjdk11
, unzip
, makeDesktopItem
, autoPatchelfHook
, icoutils
, xcbuild
, protobuf3_17
, libredirect
}:

let
  pkg_path = "$out/lib/ghidra";
  pname = "ghidra";
  version = "10.1.2";

  src = fetchFromGitHub {
    owner = "NationalSecurityAgency";
    repo = "Ghidra";
    rev = "Ghidra_${version}_build";
    sha256 = "sha256-gnSIXje0hUpAculNXAyiS7Twc5XWitMgYp7svyZQxzE=";
  };

  desktopItem = makeDesktopItem {
    name = "ghidra";
    exec = "ghidra";
    icon = "ghidra";
    desktopName = "Ghidra";
    genericName = "Ghidra Software Reverse Engineering Suite";
    categories = "Development;";
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
      export GRADLE_USER_HOME=$(mktemp -d)

      # First, fetch the static dependencies.
      gradle --no-daemon --info -Dorg.gradle.java.home=${openjdk11} -I gradle/support/fetchDependencies.gradle init

      # Then, fetch the maven dependencies.
      gradle --no-daemon --info -Dorg.gradle.java.home=${openjdk11} resolveDependencies
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
    outputHash = "sha256-UHV7Z2HaVTOCY5U0zjUtkchJicrXMBfYBHvL8AA7NTg=";
  };

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    gradle unzip makeWrapper icoutils
  ] ++ lib.optional stdenv.isDarwin xcbuild;

  dontStrip = true;

  patches = [ ./0001-Use-protobuf-gradle-plugin.patch ];
  postPatch = fixProtoc;

  buildPhase = (lib.optionalString stdenv.isDarwin ''
    export HOME=$(mktemp -d)

    # construct a dummy /etc/passwd file - something attempts to determine
    # the user's "real" home using this
    DUMMY_PASSWD=$(realpath ../dummy-passwd)
    cat > $DUMMY_PASSWD <<EOF
    $(whoami)::$(id -u):$(id -g)::$HOME:$SHELL
    EOF

    export NIX_REDIRECTS=/etc/passwd=$DUMMY_PASSWD
    export DYLD_INSERT_LIBRARIES=${libredirect}/lib/libredirect.dylib
  '') + ''

    export GRADLE_USER_HOME=$(mktemp -d)

    ln -s ${deps}/dependencies dependencies

    sed -i "s#mavenLocal()#mavenLocal(); maven { url '${deps}/maven' }#g" build.gradle

    gradle --offline --no-daemon --info -Dorg.gradle.java.home=${openjdk11} buildGhidra
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
      --prefix PATH : ${lib.makeBinPath [ openjdk11 ]}
  '';

  meta = with lib; {
    description = "A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission";
    homepage = "https://ghidra-sre.org/";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    license = licenses.asl20;
    maintainers = [ "roblabla" ];
  };

}
