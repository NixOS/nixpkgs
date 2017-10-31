{ stdenv, fetchurl, perl, getopt }:

stdenv.mkDerivation rec {
  version = "1.4";
  name = "lsb-release-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/lsb/${name}.tar.gz";
    sha256 = "0wkiy7ymfi3fh2an2g30raw6yxh6rzf6nz2v90fplbnnz2414clr";
  };

  preConfigure = ''
    substituteInPlace help2man \
      --replace /usr/bin/perl ${perl}/bin/perl
  '';

  installFlags = [ "prefix=$(out)" ];

  buildInputs = [ perl getopt ];

  meta = {
    description = "Prints certain LSB (Linux Standard Base) and Distribution information";
    homepage = http://www.linuxfoundation.org/collaborate/workgroups/lsb;
    license = [ stdenv.lib.licenses.gpl2Plus stdenv.lib.licenses.gpl3Plus ];
    platforms = stdenv.lib.platforms.linux;
  };
}
