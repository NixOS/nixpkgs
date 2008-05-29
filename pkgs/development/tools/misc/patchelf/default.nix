{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.4pre11926";
  
  src = fetchurl {
    url = http://nixos.org/releases/patchelf/patchelf-0.4pre11926-l7bh3lls/patchelf-0.4pre11926.tar.bz2;
    sha256 = "39cb2a277bb9cb6fe216694b0db3b7e364e2ec0597e437e5cb0fd4378fd172f3";
  };

  meta = {
    homepage = "http://nixos.org/patchelf.html";
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
