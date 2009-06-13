{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.5pre15500";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/31016/download/1/patchelf-0.5pre15500.tar.bz2;
    sha256 = "acc9acfc3756f8ec314b21efcd62d296ab2f74c057c2b715d3b13d521e24f5c5";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
