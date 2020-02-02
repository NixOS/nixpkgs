{ stdenv
, libopcodes, libbfd, libelf
, linuxPackages_latest, zlib
, python3
}:

stdenv.mkDerivation {
  pname = "bpftool";
  inherit (linuxPackages_latest.kernel) version src;

  nativeBuildInputs = [ python3 ];
  buildInputs = [ libopcodes libbfd libelf zlib ];

  preConfigure = ''
    patchShebangs scripts/bpf_helpers_doc.py

    cd tools/bpf/bpftool
    substituteInPlace ./Makefile \
      --replace '/usr/local' "$out" \
      --replace '/usr'       "$out" \
      --replace '/sbin'      '/bin'
  '';

  meta = with stdenv.lib; {
    description = "Debugging/program analysis tool for the eBPF subsystem";
    license     = [ licenses.gpl2 licenses.bsd2 ];
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
