{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "t1utils-1.41";

  src = fetchurl {
    url = "https://www.lcdf.org/type/${name}.tar.gz";
    sha256 = "09rlc837dr69hyiiicha3il37mchsvz84qw8hnvb60lrh9zdsppw";
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
    homepage = "http://www.lcdf.org/type/";
    # README from tarball says "BSD-like" and points to non-existing LICENSE
    # file...
    license = "Click"; # MIT with extra clause, https://github.com/kohler/t1utils/blob/master/LICENSE
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
