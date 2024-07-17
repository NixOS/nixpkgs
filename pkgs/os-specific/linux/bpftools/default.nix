{
  lib,
  stdenv,
  linuxHeaders,
  libopcodes,
  libopcodes_2_38,
  libbfd,
  libbfd_2_38,
  elfutils,
  readline,
  zlib,
  python3,
  bison,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "bpftools";

  inherit (linuxHeaders) version src;

  separateDebugInfo = true;

  patches = [
    # fix unknown type name '__vector128' on ppc64le
    ./include-asm-types-for-ppc64le.patch
  ];

  nativeBuildInputs = [
    python3
    bison
    flex
  ];
  buildInputs =
    (
      if (lib.versionAtLeast version "5.20") then
        [
          libopcodes
          libbfd
        ]
      else
        [
          libopcodes_2_38
          libbfd_2_38
        ]
    )
    ++ [
      elfutils
      zlib
      readline
    ];

  preConfigure = ''
    patchShebangs scripts/bpf_doc.py

    cd tools/bpf
    substituteInPlace ./bpftool/Makefile \
      --replace '/usr/local' "$out" \
      --replace '/usr'       "$out" \
      --replace '/sbin'      '/bin'
  '';

  buildFlags = [
    "bpftool"
    "bpf_asm"
    "bpf_dbg"
  ];

  installPhase = ''
    make -C bpftool install
    install -Dm755 -t $out/bin bpf_asm
    install -Dm755 -t $out/bin bpf_dbg
  '';

  meta = with lib; {
    homepage = "https://github.com/libbpf/bpftool";
    description = "Debugging/program analysis tools for the eBPF subsystem";
    license = [
      licenses.gpl2
      licenses.bsd2
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
