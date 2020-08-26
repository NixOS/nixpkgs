{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "rtl88xxau-aircrack-${kernel.version}-${version}";
  rev = "fc0194c1d90453bf4943089ca237159ef19a7374";
  version = "${builtins.substring 0 6 rev}";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8812au";
    inherit rev;
    sha256 = "0hf7mrvxaskc6qcjar5w81y9xc7s2rlsxp34achyqly2hjg7fgmy";
  };

  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE="-Wno-error=incompatible-pointer-types";

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

  meta = with stdenv.lib; {
    description = "Aircrack-ng kernel module for Realtek 88XXau network cards\n(8811au, 8812au, 8814au and 8821au chipsets) with monitor mode and injection support.";
    homepage = "https://github.com/aircrack-ng/rtl8812au";
    license = licenses.gpl2;
    maintainers = [ maintainers.jethro ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
