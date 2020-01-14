{ stdenv, fetchurl, fetchpatch, libuuid, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "jfsutils-1.1.15";

  src = fetchurl {
    url = "http://jfs.sourceforge.net/project/pub/${name}.tar.gz";
    sha256 = "0kbsy2sk1jv4m82rxyl25gwrlkzvl3hzdga9gshkxkhm83v1aji4";
  };

  patches = [
    ./types.patch
    ./hardening-format.patch
    # required for cross-compilation
    ./ar-fix.patch
    # fix for glibc>=2.28
    (fetchpatch {
      name   = "add_sysmacros.patch";
      url    = "https://sources.debian.org/data/main/j/jfsutils/1.1.15-4/debian/patches/add_sysmacros.patch";
      sha256 = "1qcwvxs4d0d24w5x98z59arqfx2n7f0d9xaqhjcg6w8n34vkhnyc";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libuuid ];

  meta = with stdenv.lib; {
    description = "IBM JFS utilities";
    homepage = http://jfs.sourceforge.net;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
