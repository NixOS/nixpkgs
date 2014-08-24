{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "t1utils-1.38";

  src = fetchurl {
    url = "http://www.lcdf.org/type/${name}.tar.gz";
    sha256 = "1pnxpjabjyzfjrp319wsq4acxw99c8nnsaalbz7nwamj8kkim7zw";
  };

  meta = with stdenv.lib; {
    description = "Collection of simple Type 1 font manipulation programs";
    longDescription = ''
      t1utils is a collection of simple type-1 font manipulation programs.
      Together, they allow you to convert between PFA (ASCII) and PFB (binary)
      formats, disassemble PFA or PFB files into human-readable form,
      reassemble them into PFA or PFB format. Additionally you can extract font
      resources from a Macintosh font file or create a Macintosh Type 1 font
      file from a PFA or PFB font.
    '';
    homepage = http://www.lcdf.org/type/;
    # README from tarball says "BSD-like" and points to non-existing LICENSE
    # file...
    license = "Click"; # MIT with extra clause, https://github.com/kohler/t1utils/blob/master/LICENSE
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
