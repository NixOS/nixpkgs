{stdenv, fetchurl, flex}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.0.2";
    name="${baseName}-${version}";
    hash="1xd3g28glz2xyjnca0zfw3k0jl5vhgd7wvy4n9km5wnn9z7287l2";
    url="http://ftp.gnu.org/gnu/chess/gnuchess-6.0.2.tar.gz";
    sha256="1xd3g28glz2xyjnca0zfw3k0jl5vhgd7wvy4n9km5wnn9z7287l2";
  };
  buildInputs = [
    flex
  ];
in
stdenv.mkDerivation rec {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };
  inherit buildInputs;
  meta = {
    inherit (s) version;
    description = "GNU Chess engine";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
