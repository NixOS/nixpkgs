{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "fuse-2.8.1";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/fuse/${name}.tar.gz";
    sha256 = "1brfgm2yxy060i6kcdlg30g2d48r6v9nhyxbfscpr6ijrrb10zq0";
  };
  
  configureFlags = "--disable-kernel-module";
  
  buildInputs = [ utillinux ];
  
  inherit utillinux;

  meta = {
    homepage = http://fuse.sourceforge.net/;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
  };
}
