{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.4pre11957";
  
  src = fetchurl {
    url = http://nixos.org/releases/patchelf/patchelf-0.4pre11957-lngvn112/patchelf-0.4pre11957.tar.bz2;
    sha256 = "3e9a72f17cfddcc0fbb6e2433aea7147d54c5c986c8cb3fce0dd985936efa7f3";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
