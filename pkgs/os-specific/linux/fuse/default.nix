{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "fuse-2.8.2";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/fuse/${name}.tar.gz";
    sha256 = "05sfrw4qzhsysdf1qvd89lvin36ry6rvakmm4zjhf3g1f28rwdr6";
  };
  
  configureFlags = "--disable-kernel-module";
  
  buildInputs = [ utillinux ];
  
  inherit utillinux;

  meta = {
    homepage = http://fuse.sourceforge.net/;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
  };
}
