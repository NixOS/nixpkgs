{ stdenv, fetchurl, groff }:

stdenv.mkDerivation rec {
  name = "mdadm-3.3.4";

  # WARNING -- WARNING -- WARNING -- WARNING -- WARNING -- WARNING -- WARNING
  #  Do NOT update this if you're not ABSOLUTELY certain that it will work.
  #  Please check the update using the NixOS VM test, BEFORE pushing:
  #    nix-build nixos/release.nix -A tests.installer.swraid.x86_64-linux
  # Discussion:
  #   https://github.com/NixOS/nixpkgs/commit/7719f7f
  #   https://github.com/NixOS/nixpkgs/commit/666cf99
  #   https://github.com/NixOS/nixpkgs/pull/6006
  # WARNING -- WARNING -- WARNING -- WARNING -- WARNING -- WARNING -- WARNING
  src = fetchurl {
    url = "mirror://kernel/linux/utils/raid/mdadm/${name}.tar.xz";
    sha256 = "0s6a4bq7v7zxiqzv6wn06fv9f6g502dp047lj471jwxq0r9z9rca";
  };

  patches = [ ./no-self-references.patch ];

  nativeBuildInputs = [ groff ];

  # Attempt removing if building with gcc5 when updating
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  preConfigure = "sed -e 's@/lib/udev@\${out}/lib/udev@' -e 's@ -Werror @ @' -i Makefile";

  # Force mdadm to use /var/run/mdadm.map for its map file (or
  # /dev/.mdadm/map as a fallback).
  preBuild =
    ''
      makeFlagsArray=(NIXOS=1 INSTALL=install INSTALL_BINDIR=$out/sbin MANDIR=$out/share/man RUN_DIR=/dev/.mdadm)
      if [[ -n "$crossConfig" ]]; then
        makeFlagsArray+=(CROSS_COMPILE=$crossConfig-)
      fi
    '';

  meta = {
    description = "Programs for managing RAID arrays under Linux";
    homepage = http://neil.brown.name/blog/mdadm;
  };
}
