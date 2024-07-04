{ lib
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, maven
, jdk17
, jre
, xorg
, gitUpdater
, libGL
}:

let
  mavenJdk17 = maven.override {
    jdk = jdk17;
  };
in
mavenJdk17.buildMavenPackage rec {
  pname = "runelite";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "runelite";
    repo = "launcher";
    rev = version;
    hash = "sha256-7T9n23qMl4IJQL7yWLXKvRzYcMeXDUwkY8MBFc2t3Rw=";
  };
<<<<<<< HEAD
<<<<<<< HEAD
  mvnHash = "sha256-FpfHtGIfo84z6v9/nzc47+JeIM43MR9mWhVOPSi0xhM=";
=======
  mvnHash = "sha256-bsJlsIXIIVzZyVgEF/SN+GgpZt6v0u800arO1c5QYHk=";
>>>>>>> 8cb786adbe12 (Merge pull request #324598 from r-ryantm/auto-update/ldc)
=======
  mvnHash = "sha256-bsJlsIXIIVzZyVgEF/SN+GgpZt6v0u800arO1c5QYHk=";
=======
  mvnHash = "sha256-FpfHtGIfo84z6v9/nzc47+JeIM43MR9mWhVOPSi0xhM=";
>>>>>>> 528945994acf (Merge pull request #323329 from iivusly/halloy-darwin)
>>>>>>> c7fabb43cb21 (Merge pull request #323329 from iivusly/halloy-darwin)

  desktop = makeDesktopItem {
    name = "RuneLite";
    type = "Application";
    exec = "runelite";
    icon = "runelite";
    comment = "Open source Old School RuneScape client";
    desktopName = "RuneLite";
    genericName = "Oldschool Runescape";
    categories = [ "Game" ];
  };

  # tests require internet :(
  mvnParameters = "-Dmaven.test.skip";
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/icons
    mkdir -p $out/share/applications

    cp target/RuneLite.jar $out/share
    cp appimage/runelite.png $out/share/icons

    ln -s ${desktop}/share/applications/RuneLite.desktop $out/share/applications/RuneLite.desktop

    makeWrapper ${jre}/bin/java $out/bin/runelite \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ xorg.libXxf86vm libGL ]}" \
      --add-flags "-jar $out/share/RuneLite.jar"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Open source Old School RuneScape client";
    homepage = "https://runelite.net/";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ kmeakin moody ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "runelite";
  };
}
