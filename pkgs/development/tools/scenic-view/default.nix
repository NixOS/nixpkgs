{ lib, stdenv, fetchFromGitHub, jdk, gradle_7, makeDesktopItem, makeWrapper }:
let
  pname = "scenic-view";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "JonathanGiles";
    repo = pname;
    rev = version;
    sha256 = "1idfh9hxqs4fchr6gvhblhvjqk4mpl4rnpi84vn1l3yb700z7dwy";
  };

  gradle = gradle_7;

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    exec = pname;
    comment = "JavaFx application to visualize and modify the scenegraph of running JavaFx applications.";
    mimeTypes = [ "application/java" "application/java-vm" "application/java-archive" ];
    categories = [ "Development" ];
  };

in gradle.buildPackage rec {
  inherit pname version src;
  nativeBuildInputs = [ jdk makeWrapper ];

  gradleOpts = {
    depsHash = "sha256-ICqoJevrBjAEHWnUqJ+HkgoKdOpGuJi8B8HA+EEV47Q=";
    lockfile = ./gradle.lockfile;
    buildscriptLockfile = ./buildscript-gradle.lockfile;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}
    cp build/libs/scenicview.jar $out/share/${pname}/${pname}.jar
    makeWrapper ${jdk}/bin/java $out/bin/${pname} --add-flags "-jar $out/share/${pname}/${pname}.jar"

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "JavaFx application to visualize and modify the scenegraph of running JavaFx applications.";
    longDescription = ''
      A JavaFX application designed to make it simple to understand the current state of your application scenegraph
      and to also easily manipulate properties of the scenegraph without having to keep editing your code.
      This lets you find bugs and get things pixel perfect without having to do the compile-check-compile dance.
    '';
    homepage = "https://github.com/JonathanGiles/scenic-view/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wirew0rm ];
    platforms = platforms.all;
  };
}
