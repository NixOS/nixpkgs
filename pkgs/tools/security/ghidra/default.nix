{ stdenv, fetchurl, unzip, lib, makeWrapper, autoPatchelfHook
, openjdk11, pam, makeDesktopItem, icoutils
}: let

  pkg_path = "$out/lib/ghidra";

  desktopItem = makeDesktopItem {
    name = "ghidra";
    exec = "ghidra";
    icon = "ghidra";
    desktopName = "Ghidra";
    genericName = "Ghidra Software Reverse Engineering Suite";
    categories = "Development;";
  };


in stdenv.mkDerivation {

  name = "ghidra-9.1";

  src = fetchurl {
    url = https://ghidra-sre.org/ghidra_9.1_PUBLIC_20191023.zip;
    sha256 = "0pl7s59008gvgwz4mxp7rz3xr3vaa12a6s5zvx2yr9jxx3gk1l99";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    pam
    icoutils
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
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
    maintainers = [ maintainers.ck3d ];
  };

}
