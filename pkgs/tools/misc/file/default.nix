{stdenv, fetchurl, zlib}:
 
stdenv.mkDerivation rec {
  name = "file-5.11";

  buildInputs = [ zlib ];

  src = fetchurl {
    url = "ftp://ftp.astron.com/pub/file/${name}.tar.gz";
    sha256 = "c70ae29a28c0585f541d5916fc3248c3e91baa481f63d7ccec53d1534cbcc9b7";
  };

  meta = {
    description = "A program that shows the type of files";
    homepage = "http://darwinsys.com/file";
  };
}
