{ stdenv, fetchurl, boost }:

let
  name = "source-highlight";
  version = "3.1.7";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://gnu/src-highlite/${name}-${version}.tar.gz";
    sha256 = "1s49ld8cnpzhhwq0r7s0sfm3cg3nhhm0wla27lwraifrrl3y1cp1";
  };

  buildInputs = [ boost ];

  configureFlags = [ "--with-boost=${boost.out}" ];

  enableParallelBuilding = false;

  meta = {
    description = "Source code renderer with syntax highlighting";
    homepage = http://www.gnu.org/software/src-highlite/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    longDescription =
      ''
        GNU Source-highlight, given a source file, produces a document
        with syntax highlighting.
      '';
  };
}
