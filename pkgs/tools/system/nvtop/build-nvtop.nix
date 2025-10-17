{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  cudatoolkit,
  libdrm,
  ncurses,
  testers,
  udev,
  apple-sdk_12,
  addDriverRunpath,
  amd ? false,
  intel ? false,
  msm ? false,
  nvidia ? false,
  apple ? false,
  panfrost ? false,
  panthor ? false,
  ascend ? false,
  v3d ? false,
  tpu ? false,
}:

let
  drm-postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${
        lib.makeLibraryPath [
          libdrm
          ncurses
          udev
        ]
      }" \
      $out/bin/nvtop
  '';
  needDrm = (amd || msm || panfrost || panthor || intel);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nvtop";
  version = "3.2.0";

  # between generation of multiple update PRs for each package flavor and manual updates I choose manual updates
  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = finalAttrs.version;
    hash = "sha256-8iChT55L2NSnHg8tLIry0rgi/4966MffShE0ib+2ywc=";
  };

  cmakeFlags = with lib.strings; [
    (cmakeBool "BUILD_TESTING" true)
    (cmakeBool "USE_LIBUDEV_OVER_LIBSYSTEMD" true)
    (cmakeBool "AMDGPU_SUPPORT" amd)
    (cmakeBool "NVIDIA_SUPPORT" nvidia)
    (cmakeBool "INTEL_SUPPORT" intel)
    (cmakeBool "APPLE_SUPPORT" apple)
    (cmakeBool "MSM_SUPPORT" msm)
    (cmakeBool "PANFROST_SUPPORT" panfrost)
    (cmakeBool "PANTHOR_SUPPORT" panthor)
    (cmakeBool "ASCEND_SUPPORT" ascend)
    (cmakeBool "V3D_SUPPORT" v3d)
    (cmakeBool "TPU_SUPPORT" tpu) # requires libtpuinfo which is not packaged yet
  ];
  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals finalAttrs.doCheck [
    gtest
  ]
  ++ lib.optional nvidia addDriverRunpath;

  buildInputs = [
    ncurses
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux udev
  ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_12
  ++ lib.optional nvidia cudatoolkit
  ++ lib.optional needDrm libdrm;

  # this helps cmake to find <drm.h>
  env.NIX_CFLAGS_COMPILE = lib.optionalString needDrm "-isystem ${lib.getDev libdrm}/include/libdrm";

  # ordering of fixups is important
  postFixup =
    (lib.optionalString needDrm drm-postFixup)
    + (lib.optionalString nvidia "addDriverRunpath $out/bin/nvtop");

  # https://github.com/Syllo/nvtop/commit/33ec008e26a00227a666ccb11321e9971a50daf8
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = finalAttrs.finalPackage;
      command = "nvtop --version";
    };
  };

  meta = with lib; {
    description = "htop-like task monitor for AMD, Adreno, Intel and NVIDIA GPUs";
    longDescription = ''
      Nvtop stands for Neat Videocard TOP, a (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs.
      It can handle multiple GPUs and print information about them in a htop familiar way.
    '';
    homepage = "https://github.com/Syllo/nvtop";
    changelog = "https://github.com/Syllo/nvtop/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Only;
    platforms = if apple then platforms.darwin else platforms.linux;
    maintainers = with maintainers; [
      gbtb
      anthonyroussel
      moni
    ];
    mainProgram = "nvtop";
  };
})
