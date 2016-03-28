{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.9";

  src = fetchurl {
    url = "http://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "a0f65c1ba148890e9f2f7823f4bedf7ecad5417772f64f994004f59a39014f83";
  };

  setupHook = [ ./setup-hook.sh ];

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
