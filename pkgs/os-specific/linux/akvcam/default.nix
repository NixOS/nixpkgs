{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "akvcam";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "webcamoid";
    repo = "akvcam";
    rev = version;
    sha256 = "sha256-8jQxBvWRE9Bsh0oz76gO7o+ROm6Z5QGAIe3WERIouUw=";
  };
  sourceRoot = "${src.name}/src";

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -m644 -b -D akvcam.ko $out/lib/modules/${kernel.modDirVersion}/akvcam.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Virtual camera driver for Linux";
    homepage = "https://github.com/webcamoid/akvcam";
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
