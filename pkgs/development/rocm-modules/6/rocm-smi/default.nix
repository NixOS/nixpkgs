{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  pkg-config,
  libdrm,
  cmake,
  wrapPython,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-smi";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm_smi_lib";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-qshAMVhHJIA06fGOTJx5/l1t8wKv7KbmvdCSKNuEIKM=";
  };

  patches = [ ./cmake.patch ];

  buildInputs = [
    libdrm
  ];

  nativeBuildInputs = [
    cmake
    wrapPython
    pkg-config
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
    mv $out/libexec/rocm_smi/.rsmiBindingsInit.py-wrapped $out/libexec/rocm_smi/rsmiBindingsInit.py
    mv $out/libexec/rocm_smi/.rsmiBindings.py-wrapped $out/libexec/rocm_smi/rsmiBindings.py
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/ROCm/rocm_smi_lib";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = [ "x86_64-linux" ];
  };
})
