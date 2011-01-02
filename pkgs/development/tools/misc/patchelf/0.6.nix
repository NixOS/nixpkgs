{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "patchelf-0.6pre23458";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/838169/download/2/patchelf-0.6pre23458.tar.bz2";
    sha256 = "18d74n14s4xh8aqwisvz63gx9j4d5b9bzb8k1jnp8whvvwzasdq5";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
