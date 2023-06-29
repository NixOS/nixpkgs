{ lib, stdenv, fetchurl, fetchzip, makeWrapper, jdk17, p7zip, gawk}:
let
  meta = with lib; {
    description = "Issue tracking and project management tool for developers";
    maintainers = teams.serokell.members;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    # https://www.jetbrains.com/youtrack/buy/license.html
    license = licenses.unfree;
  };

  generic = {
    version, hash,
    baseStatePath ? "/var/lib/youtrack"
  }: stdenv.mkDerivation rec {
    pname = "youtrack";
    inherit version;

    # This base version is seperated by _ instaed of . to ensure path compatability and confusion
    baseVersion = with lib; pipe version [
      versions.splitVersion
      (take 2)
      (concatStringsSep "_")
    ];

    src = fetchzip {
      url = "https://download.jetbrains.com/charisma/youtrack-${version}.zip";
      inherit hash;
    };

    nativeBuildInputs = [ makeWrapper p7zip ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/app
      cp -a . $out/app

      for path in "backups" "conf" "data" "logs" "temp"
      do
        rm -rf $out/app/$path
        ln -s ${baseStatePath}/${baseVersion}/$path $out/app/$path
      done

      makeWrapper "$out/app/bin/youtrack.sh" "$out/bin/youtrack" \
        --prefix PATH : "$out/libexec/app:${lib.makeBinPath [ jdk17 gawk ]}" \
        --set FJ_JAVA_EXEC "${jdk17}/bin/java" \
        --set JRE_HOME ${jdk17}

      runHook postInstall
    '';

    inherit meta;
  };
in {
  # We use the old YouTrack packaing still for 2022.3, because changing would
  # change the data structure.
  youtrack_2022_3 = stdenv.mkDerivation rec {
    pname = "youtrack";
    version = "2022.3.65371";
    baseVersion = "2022.3";

    jar = fetchurl {
      url = "https://download.jetbrains.com/charisma/${pname}-${version}.jar";
      sha256 = "sha256-NQKWmKEq5ljUXd64zY27Nj8TU+uLdA37chbFVdmwjNs=";
    };

    nativeBuildInputs = [ makeWrapper ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      makeWrapper ${jdk17}/bin/java $out/bin/youtrack \
        --add-flags "\$YOUTRACK_JVM_OPTS -jar $jar" \
        --prefix PATH : "${lib.makeBinPath [ gawk ]}" \
        --set JRE_HOME ${jdk17}
      runHook postInstall
    '';

    inherit meta;
  };

  youtrack_2023_1 = generic {
    version = "2023.1.10106";
    hash = "sha256-ZH8vky7ixyzuRiMQ/KzVx4dBz/UPz03w5OBTw21OiM8=";
  };
}
