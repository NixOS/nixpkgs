{
  lib,
  stdenv,
  rocmSystemsSrc,
  rocmSystemsVersion,
  cmake,
  rocm-cmake,
  rocm-runtime,
  busybox,
  python3,
  gnugrep,
}:

stdenv.mkDerivation {
  version = rocmSystemsVersion;
  pname = "rocminfo";

  src = rocmSystemsSrc;
  sourceRoot = "${rocmSystemsSrc.name}/projects/rocminfo";

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    rocm-cmake
    python3
  ];

  buildInputs = [ rocm-runtime ];
  cmakeFlags = [ "-DROCRTST_BLD_TYPE=Release" ];

  prePatch = ''
    patchShebangs rocm_agent_enumerator
    sed 's,lsmod | grep ,${busybox}/bin/lsmod | ${gnugrep}/bin/grep ,' -i rocminfo.cc
  '';

  meta = {
    description = "ROCm Application for Reporting System Info";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/rocminfo";
    license = lib.licenses.ncsa;
    mainProgram = "rocminfo";
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
