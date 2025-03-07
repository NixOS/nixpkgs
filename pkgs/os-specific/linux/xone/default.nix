{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xone";
  version = "0.3-unstable-2024-04-25";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xone";
    rev = "29ec3577e52a50f876440c81267f609575c5161e";
    hash = "sha256-ZKIV8KtrFEyabQYzWpxz2BvOAXKV36ufTI87VpIfkFs=";
  };

  patches = [
    # Fix build on kernel 6.11
    # https://github.com/medusalix/xone/pull/48
    (fetchpatch {
      name = "kernel-6.11.patch";
      url = "https://github.com/medusalix/xone/commit/28df566c38e0ee500fd5f74643fc35f21a4ff696.patch";
      hash = "sha256-X14oZmxqqZJoBZxPXGZ9R8BAugx/hkSOgXlGwR5QCm8=";
    })
    # Fix build on kernel 6.12
    # https://github.com/medusalix/xone/pull/53
    (fetchpatch {
      name = "kernel-6.12.patch";
      url = "https://github.com/medusalix/xone/commit/d88ea1e8b430d4b96134e43ca1892ac48334578e.patch";
      hash = "sha256-zQK1tuxu2ZmKxPO0amkfcT/RFBSkU2pWD0qhGyCCHXI=";
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

  enableParallelBuilding = true;
  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/medusalix/xone";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rhysmdnz ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.11";
  };
})
