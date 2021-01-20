# Tested with simple dump and restore -i, but complains that
# /nix/store/.../etc/dumpdates doesn't exist.

{ lib, stdenv, fetchurl, pkg-config,
  e2fsprogs, ncurses, readline }:

stdenv.mkDerivation rec {
  pname = "dump";
  version = "0.4b46";

  src = fetchurl {
    url = "mirror://sourceforge/dump/dump-${version}.tar.gz";
    sha256 = "15rg5y15ak0ppqlhcih78layvg7cwp6hc16p3c58xs8svlkxjqc0";
  };

  buildInputs = [ e2fsprogs pkg-config ncurses readline ];

  meta = with lib; {
    homepage = "https://dump.sourceforge.io/";
    description = "Linux Ext2 filesystem dump/restore utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ falsifian ];
  };
}
