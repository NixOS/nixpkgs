{ stdenv
, lib
, fetchgit
, jdk11
, maven
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "muon-ssh";
  version = "2.2.0";

  src = fetchgit {
    url = "https://github.com/devlinx9/muon-ssh";
    rev = "refs/tags/v2.2.0";
    hash = "sha256-eDAoKGrIBIPNLae0R0VSb0E/Nm/1TgLw2NWd3TKRibk=";
  };

  patches = [
    ./0001-fix.patch
  ];

  fetchedMavenDeps = stdenv.mkDerivation ({
    name = "${pname}-${version}-maven-deps";
    inherit src patches;

    nativeBuildInputs = [
      maven
    ];

    buildPhase = ''
      while mvn package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out/.m2 -type f -regex '.+\\(\\.lastUpdated\\|resolver-status\\.properties\\|_remote\\.repositories\\)' -delete
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-ms0Vr3kpzEqoh8oJT8uBEx4r+vZ/kU4iksmapQXPRW0=";
  });

  nativeBuildInputs = [
    maven
    jdk11
    makeWrapper
    copyDesktopItems
  ];

  buildPhase = ''
    mvnDeps=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)
    mvn -B -U package --file pom.xml --offline "-Dmaven.repo.local=$mvnDeps/.m2"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt

    cp /build/muon-ssh/muon-app/target/muonssh_${version}.jar $out/opt/${pname}-${version}.jar

    makeWrapper ${jdk11}/bin/java $out/bin/${pname} --add-flags "-jar $out/opt/${pname}-${version}.jar"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Muon SSH";
      genericName = "Muon SSH";
      comment = meta.description;
      type = "Application";
      categories = [ "Network" ];
    })
  ];

  meta = with lib; {
    description = "Easy and fun way to work with remote servers over SSH.";
    homepage = "https://github.com/devlinx9/muon-ssh";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      devpikachu
    ];
    platforms = [ "x86_64-linux" ];
  };
}
