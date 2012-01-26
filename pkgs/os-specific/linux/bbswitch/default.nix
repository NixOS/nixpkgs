{ stdenv, fetchurl, kernel }:

let

  version = "0.4.1";
  name = "bbswitch-${version}";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://github.com/downloads/Bumblebee-Project/bbswitch/${name}.tar.gz";
    sha256 = "d579c6efc5f6482f0cf0b2c1b1f1a127413218cdffdc8f2d5a946c11909bda23";
  };

  preBuild = ''
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    substituteInPlace Makefile \
      --replace "\$(shell uname -r)" "$kernelVersion" \
      --replace "/lib/modules" "${kernel}/lib/modules"
  '';
 
  installPhase = ''
    kernelVersion=$(cd ${kernel}/lib/modules && ls)
    ensureDir $out/lib/modules/$kernelVersion/misc
    cp bbswitch.ko $out/lib/modules/$kernelVersion/misc

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
