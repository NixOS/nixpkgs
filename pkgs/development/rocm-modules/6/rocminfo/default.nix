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
  clr, # Only for localGpuTargets
  # rocminfo requires that the calling user have a password and be in
  # the video group. If we let rocm_agent_enumerator rely upon
  # rocminfo's output, then it, too, has those requirements. Instead,
  # we can specify the GPU targets for this system (e.g. "gfx803" for
  # Polaris) such that no system call is needed for downstream
  # compilers to determine the desired target.
  defaultTargets ? (clr.localGpuTargets or [ ]),
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.3.3";
  pname = "rocminfo";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocminfo";
    rev = "rocm-${finalAttrs.version}";
    sha256 = "sha256-fQPtO5TNbCbaZZ7VtGkkqng5QZ+FcScdh1opWr5YkLU=";
  };

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

  postInstall = lib.optionalString (defaultTargets != [ ]) ''
    echo '${lib.concatStringsSep "\n" defaultTargets}' > $out/bin/target.lst
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "ROCm Application for Reporting System Info";
    homepage = "https://github.com/ROCm/rocminfo";
    license = licenses.ncsa;
    mainProgram = "rocminfo";
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
