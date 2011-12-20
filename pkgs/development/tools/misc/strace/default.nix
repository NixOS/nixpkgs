{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "strace-4.6";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "12n2faqq7whmszpjhv2lcb06r7900j53p0zl7vipi18inr0smycy";
  };

  buildNativeInputs = [ perl ];

  meta = {
    homepage = http://strace.sourceforge.net/;
    description = "A system call tracer for Linux";
    license = "bsd";
  };
}
