{ stdenv, fetchurl, kernel }:

let
  baseName = "bbswitch-0.5";
  name = "${baseName}-${kernel.version}";

  linux38Compatibility = fetchurl {
    url = "http://github.com/Bumblebee-Project/bbswitch/commit/5593d95.patch";
    sha256 = "0m6y5sdagf4brhk1lsp86rx94xf628sixzf6j71bn7jnqs4jslr6";
  };

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://github.com/downloads/Bumblebee-Project/bbswitch/${baseName}.tar.gz";
    sha256 = "19775r3bsf5l3ssbayr30fij09gavj2qjrr438hdcmzswvlj2dpv";
  };

  patches = [ linux38Compatibility ];

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
