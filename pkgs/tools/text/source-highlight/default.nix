{ stdenv, fetchurl, boost }:

let
  name = "source-highlight";
  version = "3.1.8";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://gnu/src-highlite/${name}-${version}.tar.gz";
    sha256 = "18xdalxg7yzrxc1njzgw7aryq2jdm7zq2yqz41sc7k6il5z6lcq1";
  };

  buildInputs = [ boost ];

  configureFlags = [ "--with-boost=${boost.out}" ];

  enableParallelBuilding = false;

  meta = {
    description = "Source code renderer with syntax highlighting";
    homepage = http://www.gnu.org/software/src-highlite/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    longDescription =
      ''
        GNU Source-highlight, given a source file, produces a document
        with syntax highlighting.
      '';
  };
}
