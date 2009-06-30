{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.5pre15975";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/35275/download/1/patchelf-0.5pre15975.tar.bz2;
    sha256 = "fa945392386c484b670c1182e354f0738b03db54d51ed6cc7ff9ebd645a20ecb";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
