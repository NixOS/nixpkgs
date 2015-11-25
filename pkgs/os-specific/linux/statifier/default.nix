{ stdenv, fetchurl, gcc_multi, glibc_multi }:

let version = "1.7.3"; in
stdenv.mkDerivation {
  name = "statifier-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/statifier/statifier-${version}.tar.gz";
    sha256 = "0jc67kq3clkdwvahpr2bjp2zix4j7z7z8b7bcn1b3g3sybh1cbd6";
  };

  buildInputs = [ gcc_multi glibc_multi ];

  phaseNames = [ "patchPhase" "installPhase" ];

  postPatch = ''
    sed -e s@/usr/@"$out/"@g -i */Makefile src/statifier
    sed -e s@/bin/bash@"${stdenv.shell}"@g -i src/*.sh
  '';

  meta = with stdenv.lib; {
    description = "Tool for creating static Linux binaries";
    platforms = platforms.linux;
  };
}
