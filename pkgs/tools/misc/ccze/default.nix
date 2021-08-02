{ lib, stdenv, fetchurl, autoconf, ncurses, pcre }:

stdenv.mkDerivation rec {
  pname = "ccze";
  version = "0.2.1-2";

  src = fetchurl {
    url = "https://github.com/madhouse/ccze/archive/ccze-${version}.tar.gz";
    sha256 = "1amavfvyls4v0gnikk43n2rpciaspxifgrmvi99qj6imv3mfg66n";
  };

  buildInputs = [ autoconf ncurses pcre ];

  preConfigure = "autoheader && autoconf ";

  meta = with lib; {
    description = "Fast, modular log colorizer";
    longDescription = ''
      Fast log colorizer written in C, intended to be a drop-in replacement
      for the Perl colorize tool.  Includes plugins for a variety of log
      formats (Apache, Postfix, Procmail, etc.).
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ malyn ];
    platforms = platforms.linux;
  };
}
