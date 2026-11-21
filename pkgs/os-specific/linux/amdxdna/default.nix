{
  lib,
  stdenv,
  kernel,
  xdna-driver,
}:

stdenv.mkDerivation {
  pname = "amdxdna";
  version = "${kernel.version}-${xdna-driver.version}";

  inherit (xdna-driver) src;

  sourceRoot = "${xdna-driver.src.name}/";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  postPatch = ''
    substituteInPlace src/driver/tools/configure_kernel.sh \
      --replace-fail '$KERNEL_SRC/include' '$KERNEL_SRC/source/include'
  '';

  configurePhase = ''
    runHook preConfigure

    pushd src
      bash driver/tools/configure_kernel.sh
    popd

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pushd src/driver/amdxdna
      make KERNEL_SRC=$KERNEL_SRC -j $NIX_BUILD_CORES
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pushd src/driver/amdxdna
      make -C $KERNEL_SRC M=$PWD/build/driver/amdxdna INSTALL_MOD_PATH=$out modules_install
    popd

    runHook postInstall
  '';

  env.KERNEL_SRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  meta = {
    description = "AMD XDNA Driver (amdxdna.ko) for Linux";
    homepage = "https://github.com/amd/xdna-driver";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = [ "x86_64-linux" ];
  };
}
