{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  pname = "rtl8821cu";
<<<<<<< HEAD
  version = "${kernel.version}-unstable-2023-04-28";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821cu-20210916";
    rev = "e49409f22ceea0d5b5ef431e6170580028b84c9d";
    hash = "sha256-mElZRr4RkRFiraBM8BxT8yesYgvDaj6xP+9T3P+0Ns4=";
=======
  version = "${kernel.version}-unstable-2022-12-07";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821cu-20210118";
    rev = "7b8c45a270454f05e2dbf3beeb4afcf817db65da";
    hash = "sha256-Dg+At0iHvi4pl8umhQyml1bODhkeK8YWYpEckqqzNcQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

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

  meta = with lib; {
    description = "Realtek rtl8821cu driver";
    homepage = "https://github.com/morrownr/8821cu";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.contrun ];
  };
}
