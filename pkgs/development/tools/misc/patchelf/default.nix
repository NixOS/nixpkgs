{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchelf-0.10";

  src = fetchurl {
    url = "https://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "1wzwvnlyf853hw9zgqq5522bvf8gqadk8icgqa41a5n7593csw7n";
  };

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
