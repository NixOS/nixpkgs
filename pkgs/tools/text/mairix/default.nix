{ stdenv, fetchurl, zlib, bzip2, bison, flex }:

stdenv.mkDerivation rec {
  name = "mairix-0.22";

  src = fetchurl {
    url = "mirror://sourceforge/mairix/${name}.tar.gz";
    sha256 = "0kwxq738nbv8ip5gkq2bw320qs1vg0pnv7wsc0p5cxwzxxrv47ql";
  };

  buildInputs = [ zlib bzip2 bison flex ];

  meta = {
    homepage = http://www.rc0.org.uk/mairix;
    license = "GPLv2+";
    description = "Program for indexing and searching email messages stored in maildir, MH or mbox";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
