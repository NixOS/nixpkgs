{ stdenv, fetchurl, pciutils, libx86, zlib }:

stdenv.mkDerivation rec {
  name = "vbetool-${version}";
  version = "1.1";

  src = fetchurl {
    url = "https://www.codon.org.uk/~mjg59/vbetool/download/${name}.tar.gz";
    sha256 = "0m7rc9v8nz6w9x4x96maza139kin6lg4hscy6i13fna4672ds9jd";
  };

  buildInputs = [ pciutils libx86 zlib ];

  patchPhase = ''
    substituteInPlace Makefile.in --replace '$(libdir)/libpci.a' ""
  '';

  configureFlags = [ "LDFLAGS=-lpci" ];

  meta = with stdenv.lib; {
    description = "Video BIOS execution tool";
    homepage = http://www.codon.org.uk/~mjg59/vbetool/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
