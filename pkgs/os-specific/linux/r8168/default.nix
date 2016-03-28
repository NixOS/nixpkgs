{ stdenv, fetchurl, nukeReferences, kernel ? null }:


with stdenv.lib;


stdenv.mkDerivation rec {
  name = "r8168-${version}-${kernel.version}";
  version = "8.041.01";

  # NOTE: there is an unnofficial github mirror for the source as well
  src = fetchurl {
    url = "http://12244.wpc.azureedge.net/8012244/drivers/rtdrivers/cn/nic/0004-r8168-8.041.01.tar.bz2";
    sha256 = "0qpc72svjcnc7i812px4b8z1jd1xjal3q4v8xa3z60nr3l2d45vh";
  };

  preBuild = ''
    ${optionalString (versionAtLeast kernel.version "4.5") "patch -p1 < ${./4.5.patch}"}
    substituteInPlace src/Makefile \
      --replace "\$(shell uname -r)" "${kernel.modDirVersion}" \
      --replace "/lib/modules" "${kernel.dev}/lib/modules" \
  '';

  makeFlags = [ "clean" "modules" ];

  installPhase = ''
      mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/"
      install -v -D -m 644 src/r8168.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  postInstall = ''
    # Prevent kernel modules from depending on the Linux -dev output.
    nuke-refs $(find $out -name "*.ko")
  '';

  meta = {
    description = "Linux kernel module for Realtek Gigabit Ethernet controllers";
    longDescription = ''
        Linux device driver released for RealTek RTL8168B/8111B, RTL8168C/8111C,
        RTL8168CP/8111CP, RTL8168D/8111D, RTL8168DP/8111DP, and RTL8168E/8111E
        Gigabit Ethernet controllers with PCI-Express interface.
      '';
    platforms = [ "x86_64-linux" "i686-linux" ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sheenobu ];
  };
}
