{ kernel
, libelf
, pkg-config
, python3
, stdenv
, zlib
, lib
, nixosTests
}:

stdenv.mkDerivation rec {
  inherit (kernel) src version;

  pname = "libbpf";

  nativeBuildInputs = [ pkg-config python3 ];
  buildInputs = [ libelf zlib ];

  enableParallelBuilding = true;
  makeFlags = [ "prefix=$(out)" ];

  passthru.tests = { inherit (nixosTests) bpf; };

  postPatch = ''
    substituteInPlace scripts/bpf_*.py \
        --replace "/usr/bin/python3" "${python3}/bin/python3" \
        --replace "/usr/bin/env python3" "${python3}/bin/python3"
  '';

  preConfigure = ''
    cd tools/lib/bpf
  '';

  # FIXME: Multi-output requires some fixes to the way the pkg-config file is
  # constructed (it gets put in $out instead of $dev for some reason, with
  # improper paths embedded). Don't enable it for now.

  # outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Common eBPF ELF object loading operations.";
    homepage = "https://kernel.org/doc/html/latest/bpf/libbpf/index.html";
    license = with licenses; [ lgpl21 /* or */ bsd2 ];
    maintainers = with maintainers; [ thoughtpolice vcunat saschagrunert martinetd ];
    platforms = platforms.linux;
  };
}
