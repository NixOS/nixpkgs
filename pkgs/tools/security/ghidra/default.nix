{ stdenv, fetchurl, unzip, lib, makeWrapper, autoPatchelfHook
, openjdk11, pam, makeDesktopItem, imagemagick
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
    imagemagick
  ];

  dontStrip = true;

  installPhase = ''
    mkdir -p "${pkg_path}"
    mkdir -p "${pkg_path}" "$out/share/applications"
    cp -a * "${pkg_path}"
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    
    convert "${pkg_path}/support/ghidra.ico" ghidra.png
    rm ghidra-3.png
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
    done;
    mv ghidra-0.png "$out/share/icons/hicolor/16x16/apps/ghidra.png"
    mv ghidra-1.png "$out/share/icons/hicolor/24x24/apps/ghidra.png"
    mv ghidra-2.png "$out/share/icons/hicolor/32x32/apps/ghidra.png"
    mv ghidra-4.png "$out/share/icons/hicolor/48x48/apps/ghidra.png"
    mv ghidra-5.png "$out/share/icons/hicolor/64x64/apps/ghidra.png"
    mv ghidra-6.png "$out/share/icons/hicolor/128x128/apps/ghidra.png"
    mv ghidra-7.png "$out/share/icons/hicolor/256x256/apps/ghidra.png"
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
