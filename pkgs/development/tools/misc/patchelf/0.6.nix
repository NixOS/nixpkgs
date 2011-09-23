{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.6pre29192";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/1319933/download/2/${name}.tar.bz2";
    sha256 = "1873d76994c112355f53d1ac6233ce334d0852ce67cae6b21f492b9b8e0b48b5";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
