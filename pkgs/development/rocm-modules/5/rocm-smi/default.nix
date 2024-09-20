{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, wrapPython
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-smi";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm_smi_lib";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-NZR4jBgKVfpkRNQFPmav1yCZF872LkcrPBNNcBVTLDU=";
  };

  patches = [ ./cmake.patch ];

  nativeBuildInputs = [
    cmake
    wrapPython
  ];

  cmakeFlags = [
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  postInstall = ''
    wrapPythonProgramsIn $out
    mv $out/libexec/rocm_smi/.rsmiBindings.py-wrapped $out/libexec/rocm_smi/rsmiBindings.py
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "System management interface for AMD GPUs supported by ROCm";
    mainProgram = "rocm-smi";
    homepage = "https://github.com/ROCm/rocm_smi_lib";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = [ "x86_64-linux" ];
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "6.0.0";
  };
})
