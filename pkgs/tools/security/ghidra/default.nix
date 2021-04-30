{ stdenv
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
  version = "9.2.3";
  versiondate = "20210325";

  src = fetchzip {
    url = "https://www.ghidra-sre.org/ghidra_${version}_PUBLIC_${versiondate}.zip";
    sha256 = "sha256-/rQ3JeOR/D+HxzkJ+nV+pd/7V81+tCyTOndwpXI05hg=";
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
