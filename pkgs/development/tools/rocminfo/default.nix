{ stdenv
, lib
, fetchFromGitHub
, rocmUpdateScript
, fetchpatch
, cmake
, rocm-runtime
, python3
, rocm-cmake
, busybox
, gnugrep
  # rocminfo requires that the calling user have a password and be in
  # the video group. If we let rocm_agent_enumerator rely upon
  # rocminfo's output, then it, too, has those requirements. Instead,
  # we can specify the GPU targets for this system (e.g. "gfx803" for
  # Polaris) such that no system call is needed for downstream
  # compilers to determine the desired target.
, defaultTargets ? []
}:

stdenv.mkDerivation (finalAttrs: {
  version = "5.4.0";
  pname = "rocminfo";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocminfo";
    rev = "rocm-${finalAttrs.version}";
    sha256 = "sha256-4wZTm5AZgG8xEd6uYqxWq4bWZgcSYZ2WYA1z4RAPF8U=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ rocm-cmake rocm-runtime ];

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

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm Application for Reporting System Info";
    homepage = "https://github.com/RadeonOpenCompute/rocminfo";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
})
