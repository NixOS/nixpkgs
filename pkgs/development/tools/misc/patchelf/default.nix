{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.9";

  src = fetchurl {
    url = "https://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "a0f65c1ba148890e9f2f7823f4bedf7ecad5417772f64f994004f59a39014f83";
  };

  setupHook = [ ./setup-hook.sh ];

  doCheck = false; # fails 8 out of 24 tests, problems when loading libc.so.6

  meta = with stdenv.lib; {
    homepage = "https://github.com/NixOS/patchelf/blob/master/README";
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
