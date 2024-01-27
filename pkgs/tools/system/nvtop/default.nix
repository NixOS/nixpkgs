{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, cudatoolkit
, libdrm
, ncurses
, nvtop
, testers
, udev
, addOpenGLRunpath
, amd ? true
, intel ? true
, msm ? true
, nvidia ? true
}:

let
  nvidia-postFixup = "addOpenGLRunpath $out/bin/nvtop";
  libPath = lib.makeLibraryPath [ libdrm ncurses udev ];
  drm-postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/nvtop
  '';
in
stdenv.mkDerivation rec {
  pname = "nvtop";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = version;
    hash = "sha256-SHKdjzbc3ZZfOW2p8RLFRKKBfLnO+Z8/bKVxcdLLqxw=";
  };

  cmakeFlags = with lib; [
    "-DBUILD_TESTING=ON"
    "-DUSE_LIBUDEV_OVER_LIBSYSTEMD=ON"
  ] ++ optional nvidia "-DNVML_INCLUDE_DIRS=${cudatoolkit}/include"
  ++ optional nvidia "-DNVML_LIBRARIES=${cudatoolkit}/targets/x86_64-linux/lib/stubs/libnvidia-ml.so"
  ++ optional (!amd) "-DAMDGPU_SUPPORT=OFF"
  ++ optional (!intel) "-DINTEL_SUPPORT=OFF"
  ++ optional (!msm) "-DMSM_SUPPORT=OFF"
  ++ optional (!nvidia) "-DNVIDIA_SUPPORT=OFF"
  ++ optional (amd || msm) "-DLibdrm_INCLUDE_DIRS=${libdrm}/lib/stubs/libdrm.so.2"
  ;
  nativeBuildInputs = [ cmake gtest ] ++ lib.optional nvidia addOpenGLRunpath;
  buildInputs = with lib; [ ncurses udev ]
    ++ optional nvidia cudatoolkit
    ++ optional (amd || msm) libdrm
  ;

  # ordering of fixups is important
  postFixup = (lib.optionalString (amd || msm) drm-postFixup) + (lib.optionalString nvidia nvidia-postFixup);

  doCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      inherit version;
      package = nvtop;
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
    changelog = "https://github.com/Syllo/nvtop/releases/tag/${version}";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz gbtb anthonyroussel ];
    mainProgram = "nvtop";
  };
}
