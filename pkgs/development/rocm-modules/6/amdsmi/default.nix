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
    rev = "esmi_pkg_ver-4.2";
    hash = "sha256-czF9ezkAO0PuDkXh8y639AcOZH+KVcWiXPX74H5W/nw=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amdsmi";
  version = "6.4.3";
  src = fetchFromGitHub {
    owner = "rocm";
    repo = "amdsmi";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-9O29O4HGkQxFDglAhHKv5KWA7p97RwMGG2x/fkOS2jE=";
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
    (fetchpatch {
      name = "esmi-to-tag-4.2.patch";
      url = "https://github.com/ROCm/amdsmi/commit/49aa2af045a4bc688e6f3ee0545f12afc45c1efe.patch";
      hash = "sha256-5dH9N4m+2mJIGVEB86SvdK3uAYyGFTfbCBJ8e09iQ3w=";
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

  meta = with lib; {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/ROCm/rocm_smi_lib";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "amd-smi";
  };
})
