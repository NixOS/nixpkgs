{ stdenv, fetchurl, boost }:

let
  name = "source-highlight";
  version = "3.1.6";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
      url = "mirror://gnu/src-highlite/${name}-${version}.tar.gz";
      sha256 = "0a5zh876nc1gig8z586b953r8ahh9zbs1lmi8vxjrkwp6zqzf4xm";
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
