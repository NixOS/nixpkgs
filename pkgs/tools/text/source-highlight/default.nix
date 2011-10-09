{ stdenv, fetchurl, boost }:

let
  name = "source-highlight";
  version = "3.1.5";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
      url = "mirror://gnu/src-highlite/${name}-${version}.tar.gz";
      sha256 = "16a2ybd0i7gk926ipp7c63mxcfwklbb20fw65npyrjzr94z1agwx";
    };

  configureFlags = [ "--with-boost=${boost}" ];

  buildInputs = [boost];
  doCheck = true;

  meta = {
    description = "GNU Source-Highlight, source code renderer with syntax highlighting";
    homepage = "http://www.gnu.org/software/src-highlite/";
    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
    longDescription =
      ''
        GNU Source-highlight, given a source file, produces a document
        with syntax highlighting.
      '';
  };
}
