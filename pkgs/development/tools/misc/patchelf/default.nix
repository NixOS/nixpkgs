{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.7";

  src = fetchurl {
    url = "http://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "61b96f455e6ccd1c1d7d159df7199c85ff6e8f9622d795a5420e418acfb8b808";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
