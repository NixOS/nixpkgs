{
  lib,
  stdenv,
  fetchFromGitHub,
  kernelModuleHook,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "v4l2loopback";
  version = "0.15.4";

  __structuredAttrs = true;
  strictDeps = true;

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

  nativeBuildInputs = [ kernelModuleHook ];

  outputs = [
    "out"
    "bin"
  ];

  # Don't use makeFlags for this
  postBuild = ''
    make utils
  '';

  postInstall = ''
    make install-utils PREFIX=$bin
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
