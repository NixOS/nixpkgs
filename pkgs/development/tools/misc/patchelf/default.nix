{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.4";
  
  src = fetchurl {
    url = http://nixos.org/releases/patchelf/patchelf-0.4/patchelf-0.4.tar.bz2;
    sha256 = "65c455b62fc52292e2488f05f46e7e38c46fdcf69c002750f5887145284c4f85";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
