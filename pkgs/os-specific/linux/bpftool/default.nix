{ stdenv, fetchurl
, libopcodes, libbfd, libelf
, linuxPackages_latest
}:

stdenv.mkDerivation rec {
  pname = "bpftool";
  inherit (linuxPackages_latest.kernel) version src;

  buildInputs = [ libopcodes libbfd libelf ];

  preConfigure = ''
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
