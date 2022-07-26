{ lib, stdenv
, libopcodes, libbfd, elfutils, readline
, linuxPackages_latest, zlib
, python3, bison, flex
}:

stdenv.mkDerivation {
  pname = "bpftools";
  inherit (linuxPackages_latest.kernel) version src;

  nativeBuildInputs = [ python3 bison flex ];
  buildInputs = [ libopcodes libbfd elfutils zlib readline ];

  preConfigure = ''
    patchShebangs scripts/bpf_doc.py

    cd tools/bpf
    substituteInPlace ./bpftool/Makefile \
      --replace '/usr/local' "$out" \
      --replace '/usr'       "$out" \
      --replace '/sbin'      '/bin'
  '';

  buildFlags = [ "bpftool" "bpf_asm" "bpf_dbg" ];

  installPhase = ''
    make -C bpftool install
    install -Dm755 -t $out/bin bpf_asm
    install -Dm755 -t $out/bin bpf_dbg
  '';

  meta = with lib; {
    description = "Debugging/program analysis tools for the eBPF subsystem";
    license     = [ licenses.gpl2 licenses.bsd2 ];
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
