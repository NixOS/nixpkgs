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
    rev = "esmi_pkg_ver-4.2";
    hash = "sha256-czF9ezkAO0PuDkXh8y639AcOZH+KVcWiXPX74H5W/nw=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amdsmi";
  version = "7.1.1";
  src = fetchFromGitHub {
    owner = "rocm";
    repo = "amdsmi";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-BGe3+8YFwu41ZVAF+VtN5Cn9pfzGxmCg/Rpq8qWOEoM=";
  };

  postPatch = ''
    substituteInPlace goamdsmi_shim/CMakeLists.txt \
      --replace-fail "amd_smi)" ${"'"}''${AMD_SMI_TARGET})' \
      --replace-fail 'target_link_libraries(''${GOAMDSMI_SHIM_TARGET} -L' '#'
    substituteInPlace CMakeLists.txt \
      --replace-fail "if(NOT latest_esmi_tag STREQUAL current_esmi_tag)" "if(OFF)"

    # Manually unpack esmi_ib_src and add amd_hsmp.h so execute-process git clone doesn't run
    cp -rf --no-preserve=mode ${esmi_ib_src} ./esmi_ib_library
    mkdir -p ./esmi_ib_library/include/asm
    cp ./include/amd_smi/impl/amd_hsmp.h ./esmi_ib_library/include/asm/amd_hsmp.h
  '';

  patches = [
    # Fix error: redefinition of 'struct drm_color_ctm_3x4'
    # https://github.com/ROCm/amdsmi/pull/165
    ./drm-struct-redefinition-fix.patch
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
    makeWrapperArgs=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libdrm ]})
    wrapPythonProgramsIn $out
    rm $out/bin/amd-smi
    ln -sf $out/libexec/amdsmi_cli/amdsmi_cli.py $out/bin/amd-smi
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/ROCm/rocm_smi_lib";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "amd-smi";
  };
})
