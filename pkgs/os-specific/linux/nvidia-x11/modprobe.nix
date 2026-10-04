{
  stdenv,
  lib,
  fetchFromGithubOrNvidia,
  gnum4,
  platforms,
  version,
  hash,
  versionCheckHook,
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

  # `nvidia-modprobe --version` prints the version of the source it was built
  # from, so a source whose hash was not updated on a version bump is caught
  # here instead of silently reusing the old tree from the store.
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postPatch = ''
    substituteInPlace utils.mk --replace-fail "/usr/local" "$out"
  '';

  meta = {
    description = "Load the NVIDIA kernel module and create NVIDIA character device files";
    homepage = "https://github.com/NVIDIA/nvidia-modprobe";
    license = lib.licenses.gpl2;
    inherit platforms;
    mainProgram = "nvidia-modprobe";
  };
})
