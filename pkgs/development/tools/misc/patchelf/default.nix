{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.8";

  src = fetchurl {
    url = "http://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "c99f84d124347340c36707089ec8f70530abd56e7827c54d506eb4cc097a17e7";
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
