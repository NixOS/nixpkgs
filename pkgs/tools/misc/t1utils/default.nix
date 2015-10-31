{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.39";
  name = "t1utils-${version}";

  src = fetchFromGitHub {
    owner = "kohler";
    repo = "t1utils";
    rev = "v${version}";
    sha256 = "02n4dzxa8fz0dbxari7xh6cq66x3az6g55fq8ix2bfmww42s4v2r";
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
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
