{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "v4l2loopback";
  version = "0.15.4";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    tag = "v${version}";
    hash = "sha256-+9wJIeEUP6iaGnfKPl06OuPW5oZdQyHuNDN/1SeHw5s=";
  };

  hardeningDisable = [
    "format"
    "pic"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  outputs = [
    "out"
    "bin"
  ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
  ];

  installFlags = [
    "DEPMOD=true"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  buildPhase = ''
    runHook preBuild
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) "''${makeFlags[@]}"
    # Don't use makeFlags for this
    make utils
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules_install \
      "''${makeFlags[@]}" "''${installFlags[@]}"
    make install-utils PREFIX=$bin
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kernel module to create V4L2 loopback devices";
    mainProgram = "v4l2loopback-ctl";
    homepage = "https://github.com/umlaeute/v4l2loopback";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      moni
      bot-wxt1221
    ];
    platforms = lib.platforms.linux;
    outputsToInstall = [ "out" ];
  };
}
