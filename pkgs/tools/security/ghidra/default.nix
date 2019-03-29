{ stdenv, fetchurl, unzip, lib, makeWrapper, autoPatchelfHook
, openjdk11, pam
}: let

  pkg_path = "$out/lib/ghidra";

in stdenv.mkDerivation {

  name = "ghidra-9.0";

  src = fetchurl {
    url = https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip;
    sha256 = "3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2";
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
