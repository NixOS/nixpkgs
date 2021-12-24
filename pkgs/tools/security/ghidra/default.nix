{ stdenv
, fetchMavenArtifact
, fetchzip
, lib
, makeWrapper
, autoPatchelfHook
, openjdk11
, pam
, makeDesktopItem
, icoutils
}:

let
  log4j-api = fetchMavenArtifact {
    groupId = "org.apache.logging.log4j";
    artifactId = "log4j-api";
    version = "2.12.3";
    sha256 = "0z9snl8h31dkwqisd6sfsh5yvf6fbg6imjc7mryzflnq1dfnk2d8";
  };

  log4j-core = fetchMavenArtifact {
    groupId = "org.apache.logging.log4j";
    artifactId = "log4j-core";
    version = "2.12.3";
    sha256 = "16idm7w073cjbk7nzbc4vcnahh9097dgp1nipj99hh6vamai32q4";
  };

  pkg_path = "$out/lib/ghidra";

  desktopItem = makeDesktopItem {
    name = "ghidra";
    exec = "ghidra";
    icon = "ghidra";
    desktopName = "Ghidra";
    genericName = "Ghidra Software Reverse Engineering Suite";
    categories = "Development;";
  };

in stdenv.mkDerivation rec {
  pname = "ghidra";
  version = "9.2.4";
  versiondate = "20210427";

  src = fetchzip {
    url = "https://www.ghidra-sre.org/ghidra_${version}_PUBLIC_${versiondate}.zip";
    sha256 = "1bfswa8mzbianmkygjhaab77g1v825dca1gdmwbzililvqlq24d6";
  };

  nativeBuildInputs = [
    makeWrapper
    icoutils
  ]
  ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    pam
  ];

  dontStrip = true;

  installPhase = ''
    mkdir -p "${pkg_path}"
    mkdir -p "${pkg_path}" "$out/share/applications"
    cp -a * "${pkg_path}"
    ln -s ${desktopItem}/share/applications/* $out/share/applications

    icotool -x "${pkg_path}/support/ghidra.ico"
    rm ghidra_4_40x40x32.png
    for f in ghidra_*.png; do
      res=$(basename "$f" ".png" | cut -d"_" -f3 | cut -d"x" -f1-2)
      mkdir -pv "$out/share/icons/hicolor/$res/apps"
      mv "$f" "$out/share/icons/hicolor/$res/apps/ghidra.png"
    done;

    # workaround for CVE-2021-44228, CVE-2021-45046, CVE-2021-45105
    rm -f $out/lib/ghidra/Ghidra/Framework/Generic/lib/{log4j-api-2.12.1.jar,log4j-core-2.12.1.jar}
    cp ${log4j-api}/share/java/*.jar ${log4j-core}/share/java/*.jar $out/lib/ghidra/Ghidra/Framework/Generic/lib
  '';

  postFixup = ''
    mkdir -p "$out/bin"
    makeWrapper "${pkg_path}/ghidraRun" "$out/bin/ghidra" \
      --prefix PATH : ${lib.makeBinPath [ openjdk11 ]}
  '';

  meta = with lib; {
    description = "A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission";
    homepage = "https://ghidra-sre.org/";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    license = licenses.asl20;
    maintainers = with maintainers; [ ck3d govanify mic92 ];
  };

}
