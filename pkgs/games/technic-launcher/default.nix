{ lib
, fetchFromGitHub
, jre
, maven
, makeWrapper
, openjdk
, xdg-utils
}:

let
  version = "1.6.56";
  src = fetchFromGitHub {
    owner = "TechnicPack";
    repo = "LauncherV3";
    rev = "2ea377bb81d6fe6a393c790fb659a134a571f03e";
    hash = "sha256-4Bh0lzCZ5/GI/2QMOkawNx/9r2zp1JjCkKTjJCobLHA=";
  };
in
maven.buildMavenPackage {
  pname = "technic-launcher";
  inherit version src;

  mvnHash = "sha256-wtLX7lSaDu0WlcJIjARAdQMSmlWUnjrZLoCO+EGeJwQ=";

  patchPhase = ''
    # Hard-code xdg-open path
    sed -i 's|ProcessBuilder("xdg-open", url)|ProcessBuilder("${xdg-utils}/bin/xdg-open", url)|g' src/main/java/net/technicpack/utilslib/DesktopUtils.java
  '';

  nativeBuildInputs = [ maven makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/java

    mv target/launcher-*.jar $out/share/java/technic-launcher-${version}.jar

    makeWrapper ${jre}/bin/java $out/bin/technic-launcher \
      --add-flags "-cp $out/share/java/technic-launcher-${version}.jar net.technicpack.launcher.LauncherMain"
    chmod +x $out/bin/technic-launcher

    runHook postInstall
  '';

  meta = with lib; {
    description = "Custom Minecraft launcher that automatically downloads and updates modpacks";
    homepage = "https://www.technicpack.net/download";
    platforms = openjdk.meta.platforms;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
