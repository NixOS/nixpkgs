{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.11";

  src = fetchurl {
    url = "https://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "16ms3ijcihb88j3x6cl8cbvhia72afmfcphczb9cfwr0gbc22chx";
  };

  setupHook = [ ./setup-hook.sh ];

  # fails 8 out of 24 tests, problems when loading libc.so.6
  doCheck = stdenv.name == "stdenv-linux";

  meta = with stdenv.lib; {
    homepage = "https://github.com/NixOS/patchelf/blob/master/README";
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
