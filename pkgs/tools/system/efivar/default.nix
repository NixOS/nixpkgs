{ stdenv, fetchgit, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "0.15";

  src = fetchgit {
    url = "git://github.com/rhinstaller/efivar.git";
    rev = "refs/tags/${version}";
    sha256 = "1k5krjghb2r04wv6kxnhs1amqwzk7khzm7bsh0wnbsz7qn92masr";
  };

  buildInputs = [ popt ];

  installFlags = [
    "libdir=$(out)/lib"
    "mandir=$(out)/share/man"
    "includedir=$(out)/include"
    "bindir=$(out)/bin"
  ];

  meta = with stdenv.lib; {
    homepage = http://github.com/vathpela/efivar;
    description = "Tools and library to manipulate EFI variables";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
