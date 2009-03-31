args: with args;

stdenv.mkDerivation {
  name = "fuse-2.7.4";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://sourceforge/fuse/fuse-2.7.4.tar.gz;
    sha256 = "1rj9xn6ynbcqp6n5pf54jcyq13viij0jhv7adv89pq6lwpn71c68";
  };
  
  configureFlags = "--disable-kernel-module";
  
  buildInputs = [utillinux];
  
  inherit utillinux;

  meta = {
    homepage = http://fuse.sourceforge.net/;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
  };
}
