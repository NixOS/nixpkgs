{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-runtime,
  busybox,
  python3,
  gnugrep,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "10.1.0";
  pname = "rocminfo";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${lib.versions.majorMinor finalAttrs.version}";
    sparseCheckout = [
      "projects/rocminfo"
      "shared"
    ];
    hash = "sha256-oK9fUtHb2qvFTpQ/9KE6LfiopDUvoreApZtsDb9aGvA=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocminfo";

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

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "ROCm Application for Reporting System Info";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/rocminfo";
    license = lib.licenses.ncsa;
    mainProgram = "rocminfo";
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
