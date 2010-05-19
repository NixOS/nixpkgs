{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "patchelf-0.6pre20950";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/379622/download/3/patchelf-0.6pre20950.tar.gz";
    sha256 = "d308c26f304e5102846a747296f9b89a8237fa8cc3685316901db1f72e66f43c";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
