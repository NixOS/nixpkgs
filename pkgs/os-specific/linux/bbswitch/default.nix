{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
  runtimeShell,
}:

let
  baseName = "bbswitch";
  version = "unstable-2021-11-29";
  name = "${baseName}-${version}-${kernel.version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "Bumblebee-Project";
    repo = "bbswitch";
    # https://github.com/Bumblebee-Project/bbswitch/tree/develop
    rev = "23891174a80ea79c7720bcc7048a5c2bfcde5cd9";
    hash = "sha256-50v1Jxem5kaI1dHOKmgBbPLxI82QeYxiaRHhrHpWRzU=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/0bd986055ba52887b81048de5c61e618eec06eb0/trunk/0003-kernel-5.18.patch";
      sha256 = "sha256-va62/bR1qyBBMPg0lUwCH7slGG0XijxVCsFa4FCoHEQ=";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "/lib/modules" "${kernel.dev}/lib/modules"
  '';

  makeFlags = kernel.makeFlags;

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc
    cp bbswitch.ko $out/lib/modules/${kernel.modDirVersion}/misc

    mkdir -p $out/bin
    tee $out/bin/discrete_vga_poweroff << EOF
    #!${runtimeShell}

    echo -n OFF > /proc/acpi/bbswitch
    EOF
    tee $out/bin/discrete_vga_poweron << EOF
    #!${runtimeShell}

    echo -n ON > /proc/acpi/bbswitch
    EOF
    chmod +x $out/bin/discrete_vga_poweroff $out/bin/discrete_vga_poweron
  '';

  meta = with lib; {
    description = "A module for powering off hybrid GPUs";
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    homepage = "https://github.com/Bumblebee-Project/bbswitch";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2Plus;
  };
}
