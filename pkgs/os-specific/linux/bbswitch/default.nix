{ stdenv, fetchurl, kernelDev }:

let
  baseName = "bbswitch";
  version = "0.7";
  name = "${baseName}-${version}-${kernelDev.version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://github.com/Bumblebee-Project/${baseName}/archive/v${version}.tar.gz";
    sha256 = "0na6gfnvmp5fjbm430ms342hmrsbr6cf78n6hldqb8js2ry3f8dw";
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
