{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, rocm-runtime, python3, rocm-cmake, busybox, gnugrep
  # rocminfo requires that the calling user have a password and be in
  # the video group. If we let rocm_agent_enumerator rely upon
  # rocminfo's output, then it, too, has those requirements. Instead,
  # we can specify the GPU targets for this system (e.g. "gfx803" for
  # Polaris) such that no system call is needed for downstream
  # compilers to determine the desired target.
, defaultTargets ? []}:
stdenv.mkDerivation rec {
  version = "4.3.1";
  pname = "rocminfo";
  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocminfo";
    rev = "rocm-${version}";
    sha256 = "sha256-n80tiSVaPTFl4imZvoFENM4KhPLxgDKz5VlOvhEYlV0=";
  };

  enableParallelBuilding = true;
  buildInputs = [ cmake rocm-cmake rocm-runtime ];
  cmakeFlags = [
    "-DROCM_DIR=${rocm-runtime}"
    "-DROCRTST_BLD_TYPE=Release"
  ];

  prePatch = ''
    sed 's,#!/usr/bin/env python3,#!${python3}/bin/python,' -i rocm_agent_enumerator
    sed 's,lsmod | grep ,${busybox}/bin/lsmod | ${gnugrep}/bin/grep ,' -i rocminfo.cc
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp rocminfo $out/bin
    cp rocm_agent_enumerator $out/bin
  '' + lib.optionalString (defaultTargets != []) ''
    echo '${lib.concatStringsSep "\n" defaultTargets}' > $out/bin/target.lst
  '';
}
