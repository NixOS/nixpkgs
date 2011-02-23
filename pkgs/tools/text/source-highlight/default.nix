{ stdenv, fetchurl, boost }:

let
  name = "source-highlight";
  version = "3.1.4";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
      url = "mirror://gnu/src-highlite/${name}-${version}.tar.gz";
      sha256 = "1jd30ansx2pld196lik6r85aifdhd0cav701vasf4ws8kc8zkcxc";
    };

  # Help it find Boost::Regex.
  preConfigure =
    '' export ax_cv_boost_regex=yes
       export link_regex=yes
       export BOOST_REGEX_LIB=-lboost_regex
    '';

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
