{ stdenv, fetchurl, kernel }:

let
  baseName = "bbswitch-0.4.2";
  name = "${baseName}-${kernel.version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://github.com/downloads/Bumblebee-Project/bbswitch/${baseName}.tar.gz";
    sha256 = "06j3cm1rk3lcbv54k0magrijykrzmkrna8n5cc274iz59842lga3";
  };

  preBuild = ''
    substituteInPlace Makefile \
      --replace "\$(shell uname -r)" "${kernel.modDirVersion}" \
      --replace "/lib/modules" "${kernel}/lib/modules"
  '';
 
  installPhase = ''
    ensureDir $out/lib/modules/${kernel.modDirVersion}/misc
    cp bbswitch.ko $out/lib/modules/${kernel.modDirVersion}/misc

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
