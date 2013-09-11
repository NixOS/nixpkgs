{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-2.0.4";

  src = fetchurl {
    url = "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz";
    sha256 = "1ikqm4w125h060dsvg9brri6ma51qn76mjjff6s1bss6sw0apxg5";
  };

  buildInputs = [ zlib ];

  meta = {
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = stdenv.lib.platforms.linux;
  };
}
