{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  pkg-config,
  libdrm,
  wrapPython,
  autoPatchelfHook,
}:

let
  esmi_ib_src = fetchFromGitHub {
    owner = "amd";
    repo = "esmi_ib_library";
    rev = "esmi_pkg_ver-3.0.3";
    hash = "sha256-q0w5c5c+CpXkklmSyfzc+sbkt4cHNxscGJA3AXwvHxQ=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amdsmi";
  version = "6.3.1";
  src = fetchFromGitHub {
    owner = "rocm";
    repo = "amdsmi";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-ZHr7G2/A4t3yH4S5urt1u8DZqGRcXpZUC/eavhkgPMY=";
  };

  postPatch = ''
    substituteInPlace goamdsmi_shim/CMakeLists.txt \
      --replace-fail "amd_smi)" ${"'"}''${AMD_SMI_TARGET})' \
      --replace-fail 'target_link_libraries(''${GOAMDSMI_SHIM_TARGET} -L' '#'

    cp -rf --no-preserve=mode ${esmi_ib_src} ./esmi_ib_library
    mkdir -p ./esmi_ib_library/include/asm
    cp ${./amd_hsmp.h} ./esmi_ib_library/include/asm/amd_hsmp.h
  '';

  patches = [ ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapPython
    autoPatchelfHook
  ];

  buildInputs = [
    libdrm
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
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = [ "x86_64-linux" ];
  };
})
