{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "patchelf-0.6pre20950";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/504657/download/2/patchelf-0.6pre22813.tar.bz2";
    sha256 = "1ml86wyl35ik3lixkcz2vlzvbcancj0dygwfh5ambjmazp2q19mh";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
