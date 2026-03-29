{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  pkg-config,
  libdrm,
  cmake,
  wrapPython,
}:

let
  source = rec {
    repo = "rocm-systems";
    version = rocmVersion;
    sourceSubdir = "projects/rocm-smi-lib";
    hash = "sha256-fbyWS/OC0rAQsqLj+YdKQfba7g7FDz3xRRR01U+OwF8=";
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
  pname = "rocm-smi";
  inherit (source) version src sourceRoot;

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

  meta = {
    inherit (source) homepage;
    description = "System management interface for AMD GPUs supported by ROCm";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = [ "x86_64-linux" ];
  };
}
