{ stdenv, fetchurl, kernelDev }:

let
  baseName = "bbswitch";
  version = "0.6";
  name = "${baseName}-${version}-${kernelDev.version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://github.com/Bumblebee-Project/${baseName}/archive/v${version}.tar.gz";
    sha256 = "1y1wggfrlpxybz5cvrbvvpqa2hh6ncazzdlg9c94sx40n6p5dcf4";
  };

  preBuild = ''
    substituteInPlace Makefile \
      --replace "\$(shell uname -r)" "${kernelDev.modDirVersion}" \
      --replace "/lib/modules" "${kernelDev}/lib/modules"
  '';

  installPhase = ''
    ensureDir $out/lib/modules/${kernelDev.modDirVersion}/misc
    cp bbswitch.ko $out/lib/modules/${kernelDev.modDirVersion}/misc

    ensureDir $out/bin
    tee $out/bin/discrete_vga_poweroff << EOF
    #!/bin/sh

    echo -n OFF > /proc/acpi/bbswitch
    EOF
    tee $out/bin/discrete_vga_poweron << EOF
    #!/bin/sh

    echo -n ON > /proc/acpi/bbswitch
    EOF
    chmod +x $out/bin/discrete_vga_poweroff $out/bin/discrete_vga_poweron
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
    description = "A module for powering off hybrid GPUs";
  };
}
