{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "6.3.3";
  src = fetchFromGitHub {
    owner = "rocm";
    repo = "amdsmi";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-hrPqd4ZWqzTG7JRfVwc1SZx6TNS0Q/LFg8yDxrM3mPo=";
  };

  postPatch = ''
    substituteInPlace goamdsmi_shim/CMakeLists.txt \
      --replace-fail "amd_smi)" ${"'"}''${AMD_SMI_TARGET})' \
      --replace-fail 'target_link_libraries(''${GOAMDSMI_SHIM_TARGET} -L' '#'

    # Manually unpack esmi_ib_src and add amd_hsmp.h so execute-process git clone doesn't run
    cp -rf --no-preserve=mode ${esmi_ib_src} ./esmi_ib_library
    mkdir -p ./esmi_ib_library/include/asm
    cp ./include/amd_smi/impl/amd_hsmp.h ./esmi_ib_library/include/asm/amd_hsmp.h
  '';

  patches = [
    # Fix ld.lld undefined reference: drmGetVersion
    (fetchpatch {
      url = "https://github.com/ROCm/amdsmi/commit/c3864bf6171970d86dc50fd23f06377736823997.patch";
      hash = "sha256-zRG1tBD8sIQCWdKfCbXC/Z/6d6NTrRYvRpddPWdM4j8=";
    })
  ];

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
    rm $out/bin/amd-smi
    ln -sf $out/libexec/amdsmi_cli/amdsmi_cli.py $out/bin/amd-smi
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
