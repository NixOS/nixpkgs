{ stdenv, fetchurl, elfutils }:

stdenv.mkDerivation rec {
  name = "ltrace-0.5.3";

  src = fetchurl {
    url = ftp://ftp.debian.org/debian/pool/main/l/ltrace/ltrace_0.5.3.orig.tar.gz;
    sha256 = "0cmyw8zyw8b1gszrwizcm53cr0mig1iw3kv18v5952m9spb2frjw";
  };

  buildInputs = [ elfutils ];

  preBuild =
    ''
      makeFlagsArray=(INSTALL="install -c")
    '';

  meta = {
    description = "Library call tracer";
    homepage = http://www.ltrace.org/;
  };
}
