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
    # The commit amdsmi pins (tag esmi_pkg_ver-5.2.1.1)
    rev = "d494a3194ceb4cc4dbb2debf9fcbe8773c6d3bef";
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
    # Pre-populate esmi_ib_library so CMake does not FetchContent it.
    cp -rf --no-preserve=mode ${esmi_ib_src} ./esmi_ib_library
    mkdir -p ./esmi_ib_library/include/asm
    cp ./include/amd_smi/impl/amd_hsmp.h ./esmi_ib_library/include/asm/amd_hsmp.h
  '';

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
    # py-interface/CMakeLists.txt fails without a system python3 unless this is set.
    "-DAMDSMI_SYSTEM_PYTHON_SITELIB=${placeholder "out"}/${python.sitePackages}"
    # libamd_smi.so still exports rsmi_init, and its own call to it goes
    # through the PLT. Once librocm_smi64 is loaded globally (torch's
    # libtorch_hip needs it), that call binds to rocm_smi's copy, amdsmi's own
    # state is never initialised, and enumeration returns no processors:
    # torch.cuda.device_count() is then 0. Upstream links only the wheel's
    # libamd_smi_python.so this way; do the same for the system library.
    "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-Bsymbolic-functions"
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
