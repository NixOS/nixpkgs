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
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    rev = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/rocm-smi-lib"
      "shared"
    ];
    hash = "sha256-Si8SbeVKUBtqk6h2QJ9ssQV68bLq6TvESrYXJuArHd8=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocm-smi-lib";

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
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
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
    # rocm-toolchain doesn't automatically add buildInputs to isystem include path like
    # wrapper based toolchains, cmake files often don't find_package(rocm-smi) so
    # can't rely on cmake propagated interface
    # upstream have been shipping libdrm copied into /opt/rocm
    + ''
      ln -s ${libdrm.dev}/include/libdrm/ $out/include/
    '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/rocm-smi-lib";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = [ "x86_64-linux" ];
  };
})
