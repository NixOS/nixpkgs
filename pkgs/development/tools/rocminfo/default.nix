{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocm-runtime
, busybox
, python3
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
  version = "5.4.1";
  pname = "rocminfo";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocminfo";
    rev = "rocm-${finalAttrs.version}";
    sha256 = "sha256-4wZTm5AZgG8xEd6uYqxWq4bWZgcSYZ2WYA1z4RAPF8U=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [ rocm-runtime ];
  propagatedBuildInputs = [ python3 ];
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
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm Application for Reporting System Info";
    homepage = "https://github.com/RadeonOpenCompute/rocminfo";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = stdenv.isAarch64 || finalAttrs.version != stdenv.cc.version;
  };
})
