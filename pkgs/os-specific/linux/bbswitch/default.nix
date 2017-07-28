{ stdenv, fetchurl, fetchpatch, kernel }:

let
  baseName = "bbswitch";
  version = "0.8";
  name = "${baseName}-${version}-${kernel.version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://github.com/Bumblebee-Project/${baseName}/archive/v${version}.tar.gz";
    sha256 = "0xql1nv8dafnrcg54f3jsi3ny3cd2ca9iv73pxpgxd2gfczvvjkn";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/Bumblebee-Project/bbswitch/pull/102.patch";
    sha256 = "1lbr6pyyby4k9rn2ry5qc38kc738d0442jhhq57vmdjb6hxjya7m";
  }) ];

  hardeningDisable = [ "pic" ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "\$(shell uname -r)" "${kernel.modDirVersion}" \
      --replace "/lib/modules" "${kernel.dev}/lib/modules"
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc
    cp bbswitch.ko $out/lib/modules/${kernel.modDirVersion}/misc

    mkdir -p $out/bin
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

  meta = with stdenv.lib; {
    description = "A module for powering off hybrid GPUs";
    platforms = platforms.linux;
    homepage = "https://github.com/Bumblebee-Project/bbswitch";
    maintainers = with maintainers; [ abbradar ];
  };
}
