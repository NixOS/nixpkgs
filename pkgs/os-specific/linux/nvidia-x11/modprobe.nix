{
  stdenv,
  lib,
  fetchFromGithubOrNvidia,
  fetchpatch,
  gnum4,
  nvidia_x11,
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

  # Another process can create the device node between the stat and the mknod.
  # Accept an existing node after checking its type and number instead of
  # failing, and leave a node we did not create alone.  The code this touches
  # is unchanged in every release from the oldest tag to the newest, so one
  # patch covers all branches.
  patches = [
    (fetchpatch {
      url = "https://github.com/ooonea/nvidia-modprobe/commit/450f0c15ad9229fe5f4d3f80ae4d95e42d9c038e.patch";
      hash = "sha256-SKJqt2MJDQxzRnfGcgB9oJHyt6Rwrm4hLh9zgIPEv/0=";
    })
  ];

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
    platforms = nvidia_x11.meta.platforms;
    mainProgram = "nvidia-modprobe";
  };
})
