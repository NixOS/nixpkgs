{ lib, stdenv, fetchFromGitHub, kernel }:

let
  rev = "ee299797bcd54d5b8c58d2da8576c54cea1a03a2";
in
stdenv.mkDerivation rec {
  pname = "rtl88xxau-aircrack";
  version = "${kernel.version}-${builtins.substring 0 6 rev}";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8812au";
    inherit rev;
    sha256 = "sha256-JUyUOqLMD9nSo6i87K/6Ljp+pWSqSBz/IZiFWu03rQw=";
  };

  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
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
