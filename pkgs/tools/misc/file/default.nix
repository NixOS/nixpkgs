{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-5.14";

  buildInputs = [ zlib ];

  src = fetchurl {
    url = "ftp://ftp.astron.com/pub/file/${name}.tar.gz";
    sha256 = "1r3zqxr7al5yy2595hd9hxwc14iij021p46d5my3n2lhs0fs06s6";
  };

  meta = {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
  };
}
