{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "fuse-2.9.2";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/fuse/${name}.tar.gz";
    sha256 = "1z6fg593hy1j7mynhckx43gqkkg2nwpmwwv860337nl77zxji9w1";
  };
  
  configureFlags = "--disable-kernel-module";
  
  buildInputs = [ utillinux ];
  
  inherit utillinux;

  meta = {
    homepage = http://fuse.sourceforge.net/;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
  };
}
