{
  stdenv,
  lib,
  fetchFromGithubOrNvidia,
  gnum4,
  nvidia_x11,
  version,
  hash,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nvidia-modprobe";
  inherit version;

  src = fetchFromGithubOrNvidia {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    tag = finalAttrs.version;
    inherit hash;
  };

  nativeBuildInputs = [ gnum4 ];

  postPatch = ''
    substituteInPlace utils.mk --replace-fail "/usr/local" "$out"
  '';

  meta = {
    description = "Load the NVIDIA kernel module and create NVIDIA character device files";
    homepage = "https://github.com/NVIDIA/nvidia-modprobe";
    license = lib.licenses.gpl2;
    platforms = nvidia_x11.meta.platforms;
    mainProgram = "nvidia-modprobe";
  };
})
