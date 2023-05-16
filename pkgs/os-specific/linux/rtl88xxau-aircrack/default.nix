{ lib, stdenv, fetchFromGitHub, kernel }:

<<<<<<< HEAD
stdenv.mkDerivation rec {
  pname = "rtl88xxau-aircrack";
  version = "${kernel.version}-unstable-02-05-2023";
=======
let
  rev = "ee299797bcd54d5b8c58d2da8576c54cea1a03a2";
in
stdenv.mkDerivation rec {
  pname = "rtl88xxau-aircrack";
  version = "${kernel.version}-${builtins.substring 0 6 rev}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8812au";
<<<<<<< HEAD
    rev = "35308f4dd73e77fa572c48867cce737449dd8548";
    hash = "sha256-0kHrNsTKRl/xTQpDkIOYqTtcHlytXhXX8h+6guvLmLI=";
=======
    inherit rev;
    sha256 = "sha256-JUyUOqLMD9nSo6i87K/6Ljp+pWSqSBz/IZiFWu03rQw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

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
    description = "Aircrack-ng kernel module for Realtek 88XXau network cards\n(8811au, 8812au, 8814au and 8821au chipsets) with monitor mode and injection support.";
    homepage = "https://github.com/aircrack-ng/rtl8812au";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.jethro ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
}
