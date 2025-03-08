{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-cmake";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-cmake";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-aVjzuJ4BiSfwOdjufFc5CznfnL8di5h992zl+pzD0DU=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/ROCm/rocm-cmake";
    license = licenses.mit;
    maintainers = teams.rocm.members;
    platforms = platforms.unix;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "6.0.0";
  };
})
