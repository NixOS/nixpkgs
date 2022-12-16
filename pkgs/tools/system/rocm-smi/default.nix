{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, wrapPython
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-smi";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm_smi_lib";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-nkidiDNNU6MGhne9EbYClkODJZw/zZu3LWzlniJKyJE=";
  };

  nativeBuildInputs = [ cmake wrapPython ];

  patches = [ ./cmake.patch ];

  postInstall = ''
    wrapPythonProgramsIn $out
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/RadeonOpenCompute/rocm_smi_lib";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = [ "x86_64-linux" ];
  };
})
