{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, cudatoolkit
, libdrm
, ncurses
, addOpenGLRunpath
, amd ? true
, nvidia ? true
}:

let
  pname-suffix = if amd && nvidia then "" else if amd then "-amd" else "-nvidia";
  nvidia-postFixup = "addOpenGLRunpath $out/bin/nvtop";
  libPath = lib.makeLibraryPath [ libdrm ncurses ];
  amd-postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/nvtop
  '';
in
stdenv.mkDerivation rec {
  pname = "nvtop" + pname-suffix;
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = version;
    sha256 = "sha256-TlhCU7PydzHG/YMlk922mxEJ3CZw40784U0w1YawI3I=";
  };

  cmakeFlags = with lib; [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_TESTING=ON"
  ] ++ optional nvidia "-DNVML_INCLUDE_DIRS=${cudatoolkit}/include"
  ++ optional nvidia "-DNVML_LIBRARIES=${cudatoolkit}/targets/x86_64-linux/lib/stubs/libnvidia-ml.so"
  ++ optional (!amd) "-DAMDGPU_SUPPORT=OFF"
  ++ optional (!nvidia) "-DNVIDIA_SUPPORT=OFF"
  ++ optional amd "-DLibdrm_INCLUDE_DIRS=${libdrm}/lib/stubs/libdrm.so.2"
  ;
  nativeBuildInputs = [ cmake gtest ] ++ lib.optional nvidia addOpenGLRunpath;
  buildInputs = with lib; [ ncurses ]
    ++ optional nvidia cudatoolkit
    ++ optional amd libdrm
  ;

  # ordering of fixups is important
  postFixup = (lib.optionalString amd amd-postFixup) + (lib.optionalString nvidia nvidia-postFixup);

  doCheck = true;

  meta = with lib; {
    description = "A (h)top like task monitor for AMD and NVIDIA GPUs";
    longDescription = ''
      Nvtop stands for Neat Videocard TOP, a (h)top like task monitor for AMD and NVIDIA GPUs. It can handle multiple GPUs and print information about them in a htop familiar way.
    '';
    homepage = "https://github.com/Syllo/nvtop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz gbtb ];
  };
}
