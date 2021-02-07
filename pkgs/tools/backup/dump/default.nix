# Tested with simple dump and restore -i, but complains that
# /nix/store/.../etc/dumpdates doesn't exist.

{ lib, stdenv, fetchurl, pkg-config,
  e2fsprogs, ncurses, readline }:

stdenv.mkDerivation rec {
  pname = "dump";
  version = "0.4b47";

  src = fetchurl {
    url = "mirror://sourceforge/dump/dump-${version}.tar.gz";
    sha256 = "sha256-0CGs3k+77T2T662YFCL2cfSNZrKeyI196DZC7Pv/T9A=";
  };

  buildInputs = [ e2fsprogs pkg-config ncurses readline ];

  meta = with lib; {
    homepage = "https://dump.sourceforge.io/";
    description = "Linux Ext2 filesystem dump/restore utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ falsifian ];
  };
}
