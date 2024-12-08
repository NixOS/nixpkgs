{
  stdenv,
  fetchzip,
  lib,
  makeWrapper,
  autoPatchelfHook,
  openjdk21,
  pam,
  makeDesktopItem,
  icoutils,
}:

let

  pkg_path = "$out/lib/ghidra";

  desktopItem = makeDesktopItem {
    name = "ghidra";
    exec = "ghidra";
    icon = "ghidra";
    desktopName = "Ghidra";
    genericName = "Ghidra Software Reverse Engineering Suite";
    categories = [ "Development" ];
    terminal = false;
    startupWMClass = "ghidra-Ghidra";
  };

in
stdenv.mkDerivation rec {
  pname = "ghidra";
  version = "11.2.1";
  versiondate = "20241105";

  src = fetchzip {
    url = "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${version}_build/ghidra_${version}_PUBLIC_${versiondate}.zip";
    hash = "sha256-w6FCAjF2ggFWH8eo7X8V6ZTbSptGkwRzoEMj9nGL5/M=";
  };

  nativeBuildInputs = [
    makeWrapper
    icoutils
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
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
    ln -s "${pkg_path}/ghidraRun" "$out/bin/ghidra"
    ln -s "${pkg_path}/support/analyzeHeadless" "$out/bin/ghidra-analyzeHeadless"

    wrapProgram "${pkg_path}/support/launch.sh" \
      --prefix PATH : ${lib.makeBinPath [ openjdk21 ]}
  '';

  meta = with lib; {
    description = "Software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission";
    mainProgram = "ghidra";
    homepage = "https://github.com/NationalSecurityAgency/ghidra";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [
      ck3d
      govanify
      mic92
    ];
  };

}
