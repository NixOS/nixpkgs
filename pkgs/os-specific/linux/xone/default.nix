{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xone";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dlundqvist";
    repo = "xone";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Ca7JsyFGsi6iiNusbEgIGc3jHeNLBwKKYzqcm3O6GxU=";
=======
    hash = "sha256-EXJBqzO4e2SJGrPvB0VYzIQf09uo5OfNdBQw5UqskYg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  enableParallelBuilding = true;
  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

<<<<<<< HEAD
  meta = {
    description = "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/dlundqvist/xone";
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/dlundqvist/xone";
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [
      rhysmdnz
      fazzi
    ];
<<<<<<< HEAD
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "6.5";
=======
    platforms = platforms.linux;
    broken = kernel.kernelOlder "6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
