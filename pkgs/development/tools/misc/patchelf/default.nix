{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.9";

  src = fetchurl {
    url = "https://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "a0f65c1ba148890e9f2f7823f4bedf7ecad5417772f64f994004f59a39014f83";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/NixOS/patchelf/commit/52ab908394958a2a5d0476e306e2cad4da4fdeae.patch";
      sha256 = "1mwnjmd2gfyk6mmqnwd3h7810capj74pfxb16p2xk7vap0375sr8";
    })
  ];

  setupHook = [ ./setup-hook.sh ];

  doCheck = false; # fails 8 out of 24 tests, problems when loading libc.so.6

  meta = with stdenv.lib; {
    homepage = https://nixos.org/patchelf.html;
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
