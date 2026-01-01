{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
}:

stdenv.mkDerivation {
  pname = "rtl88x2bu";
<<<<<<< HEAD
  version = "${kernel.version}-unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "RinCat";
    repo = "RTL88x2BU-Linux-Driver";
    rev = "825556e195ecde9ce8f5f4cbad9953f398c8598e";
    hash = "sha256-MkvVCWyMOCBzCRufbKMuaaFOPhokZdFnXHYnrAwBe6M=";
=======
  version = "${kernel.version}-unstable-2025-05-29";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "88x2bu-20210702";
    rev = "fe48647496798cac77976e310ee95da000b436c9";
    hash = "sha256-h20vwCgLOiNh0LN3MGwPl3F/PSWGc2XS4t1sdeFAOko=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags;

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Realtek rtl88x2bu driver";
    homepage = "https://github.com/RinCat/RTL88x2BU-Linux-Driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      otavio
      claymorwan
    ];
    broken = kernel.kernelOlder "5.11";
=======
  meta = with lib; {
    description = "Realtek rtl88x2bu driver";
    homepage = "https://github.com/morrownr/88x2bu-20210702";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ otavio ];
    broken = kernel.kernelAtLeast "6.17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
