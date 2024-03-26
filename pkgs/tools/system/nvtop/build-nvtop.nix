{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, cudatoolkit
, libdrm
, ncurses
, testers
, udev
, addOpenGLRunpath
, amd ? false
, intel ? false
, msm ? false
, nvidia ? false
, apple ? false
, panfrost ? false
, panthor ? false
, ascend ? false
}:

let
  drm-postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ libdrm ncurses udev ]}" \
      $out/bin/nvtop
  '';
  needDrm = (amd || msm || panfrost || panthor);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nvtop";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = finalAttrs.version;
    hash = "sha256-MkkBY2PR6FZnmRMqv9MWqwPWRgixfkUQW5TWJtHEzwA=";
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
  ];
  nativeBuildInputs = [ cmake gtest ] ++ lib.optional nvidia addOpenGLRunpath;

  buildInputs = with lib; [ ncurses udev ]
    ++ optional nvidia cudatoolkit
    ++ optional needDrm libdrm
  ;

  # this helps cmake to find <drm.h>
  env.NIX_CFLAGS_COMPILE = lib.optionalString needDrm "-isystem ${lib.getDev libdrm}/include/libdrm";

  # ordering of fixups is important
  postFixup = (lib.optionalString needDrm drm-postFixup) + (lib.optionalString nvidia "addOpenGLRunpath $out/bin/nvtop");

  doCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = finalAttrs.finalPackage;
      command = "nvtop --version";
    };
  };

  meta = with lib; {
    description = "A (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs";
    longDescription = ''
      Nvtop stands for Neat Videocard TOP, a (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs.
      It can handle multiple GPUs and print information about them in a htop familiar way.
    '';
    homepage = "https://github.com/Syllo/nvtop";
    changelog = "https://github.com/Syllo/nvtop/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz gbtb anthonyroussel ];
    mainProgram = "nvtop";
  };
})
