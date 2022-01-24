{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel, runtimeShell }:

let
  baseName = "bbswitch";
  version = "0.8";
  name = "${baseName}-${version}-${kernel.version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "Bumblebee-Project";
    repo = "bbswitch";
    rev = "v${version}";
    hash = "sha256-FHC8myKnouNDERVds2QCJj1ZstjHrOzFpb+FDiSBjL4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Bumblebee-Project/bbswitch/pull/102.patch";
      sha256 = "1lbr6pyyby4k9rn2ry5qc38kc738d0442jhhq57vmdjb6hxjya7m";
    })
    (fetchpatch {
      url = "https://github.com/Bumblebee-Project/bbswitch/pull/196.patch";
      sha256 = "02ihy3piws7783qbm9q0mb9s18ipn5ckdy1iar74xn31qjrsn99n";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "\$(shell uname -r)" "${kernel.modDirVersion}" \
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
    platforms = [ "x86_64-linux" "i686-linux" ];
    homepage = "https://github.com/Bumblebee-Project/bbswitch";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2Plus;
  };
}
