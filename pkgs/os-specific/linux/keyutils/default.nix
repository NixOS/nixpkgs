{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "keyutils-${version}";
  version = "1.5.10";

  src = fetchurl {
    url = "https://people.redhat.com/dhowells/keyutils/${name}.tar.bz2";
    sha256 = "1dmgjcf7mnwc6h72xkvpaqpzxw8vmlnsmzz0s27pg0giwzm3sp0i";
  };

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
