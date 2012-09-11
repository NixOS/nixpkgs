{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.7pre160_1c057cd";

  src = fetchurl {
    url = http://hydra.nixos.org/build/2961500/download/2/patchelf-0.7pre160_1c057cd.tar.bz2;
    sha256 = "bbc46169f6b6803410e0072cf57e631481e3d5f1dde234f4eacbccb6562c5f4f";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
