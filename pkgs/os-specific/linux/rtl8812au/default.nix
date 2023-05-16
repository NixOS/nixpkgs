{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "rtl8812au";
  version = "${kernel.version}-unstable-2023-07-22";
=======
stdenv.mkDerivation rec {
  pname = "rtl8812au";
  version = "${kernel.version}-unstable-2023-01-17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8812au-20210629";
<<<<<<< HEAD
    rev = "b5f4e6e894eca8fea38661e2fc22a2570e0274ad";
    hash = "sha256-3uPowesJVh/cnagMz/Uadb+U5rDUAWfU39tZaDNCoqg=";
=======
    rev = "0a8bb3cec3ef91e6ef8cf549ca926016ba0a8acd";
    sha256 = "sha256-25NaMQq9H6mqVynNQJXpqISAslxfEVSt3ELzG7s4mV4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ bc nukeReferences ] ++ kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" "format" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Driver for Realtek 802.11ac, rtl8812au, provides the 8812au mod";
    homepage = "https://github.com/morrownr/8812au-20210629";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
