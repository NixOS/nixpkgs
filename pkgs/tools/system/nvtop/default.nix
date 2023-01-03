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
, nvidia ? true
}:

let
  pname-suffix = if amd && nvidia then "" else if amd then "-amd" else "-nvidia";
  nvidia-postFixup = "addOpenGLRunpath $out/bin/nvtop";
  libPath = lib.makeLibraryPath [ libdrm ncurses udev ];
  amd-postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/nvtop
  '';
in
stdenv.mkDerivation rec {
  pname = "nvtop" + pname-suffix;
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = version;
    hash = "sha256-vLvt2sankpQWAVZBPo3OePs4LDy7YfVnMkZLfN6ERAc=";
  };

  cmakeFlags = with lib; [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_TESTING=ON"
    "-DUSE_LIBUDEV_OVER_LIBSYSTEMD=ON"
  ] ++ optional nvidia "-DNVML_INCLUDE_DIRS=${cudatoolkit}/include"
  ++ optional nvidia "-DNVML_LIBRARIES=${cudatoolkit}/targets/x86_64-linux/lib/stubs/libnvidia-ml.so"
  ++ optional (!amd) "-DAMDGPU_SUPPORT=OFF"
  ++ optional (!nvidia) "-DNVIDIA_SUPPORT=OFF"
  ++ optional amd "-DLibdrm_INCLUDE_DIRS=${libdrm}/lib/stubs/libdrm.so.2"
  ;
  nativeBuildInputs = [ cmake gtest ] ++ lib.optional nvidia addOpenGLRunpath;
  buildInputs = with lib; [ ncurses udev ]
    ++ optional nvidia cudatoolkit
    ++ optional amd libdrm
  ;

  # ordering of fixups is important
  postFixup = (lib.optionalString amd amd-postFixup) + (lib.optionalString nvidia nvidia-postFixup);

  doCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      inherit version;
      package = nvtop;
      command = "nvtop --version";
    };
  };

  meta = with lib; {
    description = "A (h)top like task monitor for AMD, Intel and NVIDIA GPUs";
    longDescription = ''
      Nvtop stands for Neat Videocard TOP, a (h)top like task monitor for AMD, Intel and NVIDIA GPUs. It can handle multiple GPUs and print information about them in a htop familiar way.
    '';
    homepage = "https://github.com/Syllo/nvtop";
    changelog = "https://github.com/Syllo/nvtop/releases/tag/${version}";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz gbtb anthonyroussel ];
    mainProgram = "nvtop";
  };
}
