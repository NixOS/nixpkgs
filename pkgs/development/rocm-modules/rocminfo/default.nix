{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  cmake,
  rocm-cmake,
  rocm-runtime,
  busybox,
  python3,
  gnugrep,
}:

let
  source = rec {
    repo = "rocm-systems";
    version = rocmVersion;
    sourceSubdir = "projects/rocminfo";
    hash = "sha256-0esRBEXVibC2uzyonpc0ABNNHQ2NAWZrBmmg6p1zP0c=";
    src = fetchRocmMonorepoSource {
      inherit
        hash
        repo
        sourceSubdir
        version
        ;
    };
    sourceRoot = "${src.name}/${sourceSubdir}";
    homepage = "https://github.com/ROCm/${repo}/tree/rocm-${version}/${sourceSubdir}";
  };
in
stdenv.mkDerivation {
  pname = "rocminfo";
  inherit (source) version src sourceRoot;

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
    inherit (source) homepage;
    description = "ROCm Application for Reporting System Info";
    license = lib.licenses.ncsa;
    mainProgram = "rocminfo";
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
