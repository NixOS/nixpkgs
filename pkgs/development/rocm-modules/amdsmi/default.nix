{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  pkg-config,
  libdrm,
  libnl,
  libmnl,
  python,
  wrapPython,
  autoPatchelfHook,
  binutils,
}:

let
  esmi_ib_src = fetchFromGitHub {
    owner = "amd";
    repo = "esmi_ib_library";
    # amdsmi 27 pins esmi commit d494a319 = tag esmi_pkg_ver-5.2.1.1
    tag = "esmi_pkg_ver-5.2.1.1";
    hash = "sha256-StSYzyIujaH8UJIRpfJC0lf+oVT9fWflJgQONvRqu70=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amdsmi";
  version = "10.1";
  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/amdsmi"
      "shared"
    ];
    hash = "sha256-CmCVPmqgU0HtqIBuJUs+Nr7LRKtngOaNNsWFek9Nino=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/amdsmi";

  postPatch = ''
    # Provide esmi_ib_library locally so CMake's FetchContent branch
    # (if NOT EXISTS esmi_ib_library/src/e_smi.c) is never taken. The source has
    # no .git, so the pin-hash check is skipped and CMake copies amd_hsmp.h itself.
    cp -rf --no-preserve=mode ${esmi_ib_src} ./esmi_ib_library
    mkdir -p ./esmi_ib_library/include/asm
    cp ./include/amd_smi/impl/amd_hsmp.h ./esmi_ib_library/include/asm/amd_hsmp.h
  '';

  patches = [
    # Fix error: redefinition of 'struct drm_color_ctm_3x4'
    # Based on https://github.com/ROCm/amdsmi/pull/165
    ./drm-mode-remove-color-ctm-3x4.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapPython
    autoPatchelfHook
    binutils # CMake resolves link-lib SONAMEs via `objdump -p`
  ];

  buildInputs = [
    libdrm
    libnl # pkg_check_modules libnl-3.0 + libnl-genl-3.0
    libmnl # pkg_check_modules libmnl
  ];

  cmakeFlags = [
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    # amdsmi's py-interface/CMakeLists.txt FATAL_ERRORs at
    # configure time if it cannot locate a system python3 (it probes
    # /usr/bin/python3 and /usr/libexec/platform-python, neither of which exists
    # in the sandbox) unless AMDSMI_SYSTEM_PYTHON_SITELIB is set explicitly. The
    # actual site-packages install it guards is DESTDIR-gated (nix uses
    # CMAKE_INSTALL_PREFIX, not DESTDIR) and thus skipped; the module is always
    # staged under share/amd_smi, which the postInstall symlink below exposes on
    # sys.path. So this value only satisfies the guard — point it at nix's
    # sitePackages for correctness.
    "-DAMDSMI_SYSTEM_PYTHON_SITELIB=${placeholder "out"}/${python.sitePackages}"
  ];

  postInstall = ''
    mkdir -p $out/${python.sitePackages}
    ln -s $out/share/amd_smi/amdsmi $out/${python.sitePackages}/amdsmi

    makeWrapperArgs=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libdrm ]})
    wrapPythonProgramsIn $out
    rm $out/bin/amd-smi
    ln -sf $out/libexec/amdsmi_cli/amdsmi_cli.py $out/bin/amd-smi
  '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/amdsmi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "amd-smi";
  };
})
