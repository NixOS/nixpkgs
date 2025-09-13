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
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm_smi_lib";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-yJ3Bf+tM39JWbY+A0NlpHNkvythdAdz6ZVp1AvLcXhk=";
  };

  patches = [
    ./cmake.patch
  ];

  propagatedBuildInputs = [
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

  postInstall =
    # wrap python programs, but undo two that need to be importable at that path
    ''
      wrapPythonProgramsIn $out
      mv $out/libexec/rocm_smi/.rsmiBindingsInit.py-wrapped $out/libexec/rocm_smi/rsmiBindingsInit.py
      mv $out/libexec/rocm_smi/.rsmiBindings.py-wrapped $out/libexec/rocm_smi/rsmiBindings.py
    ''
    # workaround: propagate libdrm/ manually
    # rocmcxx doesn't automatically add buildInputs to isystem include path like
    # wrapper based toolchains, cmake files often don't find_package(rocm-smi) so
    # can't rely on cmake propagated interface
    # upstream have been shipping libdrm copied into /opt/rocm
    + ''
      ln -s ${libdrm.dev}/include/libdrm/ $out/include/
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
