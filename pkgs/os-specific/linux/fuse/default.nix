{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "fuse-2.9.3";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/fuse/${name}.tar.gz";
    sha256 = "071r6xjgssy8vwdn6m28qq1bqxsd2bphcd2mzhq0grf5ybm87sqb";
  };
  
  configureFlags = "--disable-kernel-module";
  
  buildInputs = [ utillinux ];
  
  inherit utillinux;

  meta = {
    homepage = http://fuse.sourceforge.net/;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
  };
}
