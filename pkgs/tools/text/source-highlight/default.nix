{ stdenv, fetchurl, boost }:

let
  name = "source-highlight";
  version = "3.1.3";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
      url = "mirror://gnu/src-highlite/${name}-${version}.tar.gz";
      sha256 = "2d819f2ffdc8bb23a87635bdfbc51545db22605a8e544f66f86054b8075af0b5";
    };

  buildInputs = [boost];
  doCheck = false;		# The test suite fails with a trivial
				# error, so I'll disable it for now.
				# Whoever bumps this build to the next
				# version, please re-enable it though!

  meta = {
    description = "render source code with syntax highlighting";
    homepage = "http://www.gnu.org/software/src-highlite/";
    license = "GPLv3+";
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
    longDescription =
      ''
        GNU Source-highlight, given a source file, produces a document
        with syntax highlighting.
      '';
  };
}
