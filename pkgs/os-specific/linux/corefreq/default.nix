{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  # See the official readme for a list of optional flags:
  # https://github.com/cyring/CoreFreq/blob/master/README.md
  extraFlags ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corefreq";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "cyring";
    repo = "CoreFreq";
    tag = finalAttrs.version;
    hash = "sha256-tqZ1yRx8e43Z2ca6V/a7ndd9gOdHE1aDHDnh+5VmD5w=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  env.NIX_CFLAGS_COMPILE = "-I${finalAttrs.src}/${stdenv.hostPlatform.qemuArch}";
  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ]
  ++ extraFlags;

  preInstall = ''
    mkdir -p $out/bin
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "CPU monitoring and tuning software designed for 64-bit processors";
    homepage = "https://github.com/cyring/CoreFreq";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mrene ];
    mainProgram = "corefreq-cli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
