{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "patchelf-0.5";
  
  src = fetchurl {
    url = "http://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "24b9a850af45e1a277e234b9eb090b52305a2e1c6b02addeb3ae98b4b49d37ce";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
