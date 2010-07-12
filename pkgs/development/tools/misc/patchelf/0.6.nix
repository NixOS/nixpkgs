{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "patchelf-0.6pre22275";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/479721/download/3/patchelf-0.6pre22275.tar.gz";
    sha256 = "ccce84285d145b300e5727b1562f4f334c53721fc7b388928c3fb5b9a90c7d80";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
