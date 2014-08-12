{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-5.17";

  buildInputs = [ zlib ];

  src = fetchurl {
    url = "ftp://ftp.astron.com/pub/file/${name}.tar.gz";
    sha256 = "1jl31jli87s5xnjq14r1fh72qc95562qbr5f63d68yrq3ca9gsrz";
  };

  meta = {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
    platforms = with stdenv.lib.platforms; allBut darwin;
  };
}
