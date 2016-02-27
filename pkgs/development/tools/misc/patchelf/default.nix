{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.9";

  src = fetchurl {
    #url = "http://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    url = http://hydra.nixos.org/build/32429884/download/2/patchelf-0.9pre265_498aa37.tar.bz2;
    sha256 = "f762813ad493ad73afb7846a530fe2f5e40a5d89b7dba228ce0c62651e9c851e";
  };

  setupHook = [ ./setup-hook.sh ];

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
