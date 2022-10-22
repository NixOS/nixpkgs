{ lib, stdenv, fetchFromGitHub, kernel }:

let
  rev = "37e27f9165300c89607144b646545fac576ec510";
in
stdenv.mkDerivation rec {
  pname = "rtl88xxau-aircrack";
  version = "${kernel.version}-${builtins.substring 0 6 rev}";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8812au";
    inherit rev;
    sha256 = "sha256-TpmpueKAaCe7Nlmv8pMvgMXGVmXVa/1mBwtEoy4JyCY=";
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

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Aircrack-ng kernel module for Realtek 88XXau network cards\n(8811au, 8812au, 8814au and 8821au chipsets) with monitor mode and injection support.";
    homepage = "https://github.com/aircrack-ng/rtl8812au";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.jethro ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    broken = kernel.kernelAtLeast "5.18";
  };
}
