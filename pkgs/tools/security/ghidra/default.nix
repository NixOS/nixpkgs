{ stdenv, fetchurl, unzip, lib, makeWrapper, patchelf
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
    patchelf
    unzip
  ];

  dontStrip = true;

  postPatch = ''
    for f in Ghidra/Features/Decompiler/os/linux64/* GPL/DemanglerGnu/os/linux64/*; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" "$f"
    done

    for f in Ghidra/Features/GhidraServer/os/linux64/*; do
      patchelf --set-rpath "${stdenv.cc.libc}/lib:${pam}/lib" "$f"
    done
  '';

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
