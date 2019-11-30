{ stdenv, fetchurl, unzip, lib, makeWrapper, autoPatchelfHook
, openjdk11, pam
}: let

  pkg_path = "$out/lib/ghidra";

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
  ];

  dontStrip = true;

  installPhase = ''
    mkdir -p "${pkg_path}"
    cp -a * "${pkg_path}"
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
