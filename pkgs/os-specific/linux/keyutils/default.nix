{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "keyutils";
  version = "1.6.1";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/${pname}-${version}.tar.gz";
    sha256 = "0mzmw8c7gqmqaxm3sa0xki8ycjla47xxhqg0yh17pl00d7ydqw9w";
  };

  patches = [
    (fetchurl {
      # improve reproducibility
      url = "https://salsa.debian.org/debian/keyutils/raw/4cecffcb8e2a2aa4ef41777ed40e4e4bcfb2e5bf/debian/patches/Make-build-reproducible.patch";
      sha256 = "0wnvbjfrbk7rghd032z684l7vk7mhy3bd41zvhkrhgp3cd5id0bm";
    })
    ./conf-symlink.patch
  ];

  BUILDDATE = "1970-01-01";
  outputs = [ "out" "lib" "dev" ];

  installFlags = [
    "ETCDIR=$(out)/etc"
    "BINDIR=$(out)/bin"
    "SBINDIR=$(out)/sbin"
    "SHAREDIR=$(out)/share/keyutils"
    "MANDIR=$(out)/share/man"
    "INCLUDEDIR=$(dev)/include"
    "LIBDIR=$(lib)/lib"
    "USRLIBDIR=$(lib)/lib"
  ];

  meta = with stdenv.lib; {
    homepage = https://people.redhat.com/dhowells/keyutils/;
    description = "Tools used to control the Linux kernel key management system";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
