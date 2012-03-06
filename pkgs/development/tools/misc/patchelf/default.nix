{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.6";

  src = fetchurl {
    url = "http://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "fc7e7fa95f282fc37a591a802629e0e1ed07bc2a8bf162228d9a69dd76127c01";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
