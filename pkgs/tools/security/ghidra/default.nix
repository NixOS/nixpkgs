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

  writeShellApplication,
  nix-update,
  curl,
  jq,
  gnused,
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
  version = "12.0";
  versiondate = "20251205";
  src = fetchzip {
    url = "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${version}_build/ghidra_${version}_PUBLIC_${versiondate}.zip";
    hash = "sha256-uNFI24UIFfoHjX/xTlr0tuVvesTuf4WkTC9NtVb8UlI=";
  };

  nativeBuildInputs = [
    makeWrapper
    icoutils
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "ghidra-bin-update";
      runtimeInputs = [
        curl
        jq
        gnused
        nix-update
      ];

      text = ''
        IFS=$'\n' read -d ''' -r version versiondate < <( \
          curl 'https://api.github.com/repos/NationalSecurityAgency/ghidra/releases?per_page=1' | \
            jq -r '(.[0].tag_name | capture("Ghidra_(?<v>.+)_build")).v,
                   (.[0].assets[0].browser_download_url | capture("ghidra_.+_PUBLIC_(?<v>\\d+).zip")).v' \
        ) || true
        sed -i -E \
          -e "s/versiondate = \"[0-9]+\"/versiondate = \"$versiondate\"/" \
          pkgs/tools/security/ghidra/default.nix
        nix-update --version "$version" ghidra-bin
      '';
    });
  };

  meta = {
    description = "Software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission";
    mainProgram = "ghidra";
    homepage = "https://github.com/NationalSecurityAgency/ghidra";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ck3d
      govanify
      mic92
    ];
  };

}
