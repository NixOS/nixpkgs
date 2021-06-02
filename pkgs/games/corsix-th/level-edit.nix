{ baseName ? "corsixth", version ? "trunk", stdenv, lib, githubSource, openjdk11, makeWrapper, ant }:

stdenv.mkDerivation rec {
  inherit version;

  pname = "${baseName}-leveledit";

  src = "${githubSource}/LevelEdit";

  nativeBuildInputs = [
    openjdk11
    makeWrapper
    ant
  ];

  buildPhase = ''
    ant init compile dist
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/java

    cp dist/LevelEdit.jar $out/share/java

    makeWrapper ${openjdk11}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/LevelEdit.jar" \
      --prefix PATH : "$wrappedPath"
  '';

  meta = with lib; {
    description = "Open source clone of Theme Hospital";
    longDescription = "A reimplementation of the 1997 Bullfrog business sim Theme Hospital. As well as faithfully recreating the original, CorsixTH adds support for modern operating systems (Windows, macOS, Linux and BSD), high resolutions and much more.";
    homepage = "https://github.com/CorsixTH/CorsixTH";
    maintainers = with maintainers; [ alexandre-lavoie ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
