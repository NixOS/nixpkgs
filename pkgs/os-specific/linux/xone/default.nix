{ stdenv, lib, fetchFromGitHub, kernel, fetchpatch }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xone";
  version = "0.3-unstable-2024-03-16";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xone";
    rev = "948d2302acdd6333295eaba4da06d96677290ad3";
    hash = "sha256-srAEw1ai5KT0rmVUL3Dut9R2mNb00AAZVCcINikh2sM=";
  };

  patches = [
    # Fix build on kernel 6.11
    # https://github.com/medusalix/xone/pull/48
    (fetchpatch {
      name = "kernel-6.11.patch";
      url = "https://github.com/medusalix/xone/commit/28df566c38e0ee500fd5f74643fc35f21a4ff696.patch";
      hash = "sha256-X14oZmxqqZJoBZxPXGZ9R8BAugx/hkSOgXlGwR5QCm8=";
    })
  ];

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/medusalix/xone";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rhysmdnz ];
    platforms = platforms.linux;
  };
}
)
