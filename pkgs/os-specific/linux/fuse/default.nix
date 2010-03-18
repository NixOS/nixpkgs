{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "fuse-2.8.3";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/fuse/${name}.tar.gz";
    sha256 = "5edf7f73676976126893c528578c1bf0a264cc34ca8bad7e341e0664157ff2b9";
  };
  
  configureFlags = "--disable-kernel-module";
  
  buildInputs = [ utillinux ];
  
  inherit utillinux;

  meta = {
    homepage = http://fuse.sourceforge.net/;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
  };
}
