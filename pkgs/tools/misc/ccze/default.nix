{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  ncurses,
  pcre,
}:

stdenv.mkDerivation rec {
  pname = "ccze";
  version = "0.2.1-2";

  src = fetchFromGitHub {
    owner = "madhouse";
    repo = "ccze";
    rev = "ccze-${version}";
    hash = "sha256-LVwmbrq78mZcAEuAqjXTqLE5we83H9mcMPtxQx2Tn/c=";
  };

  nativeBuildInputs = [ autoconf ];

  buildInputs = [
    ncurses
    pcre
  ];

  preConfigure = ''
    autoheader
    autoconf
  '';

  meta = with lib; {
    description = "Fast, modular log colorizer";
    longDescription = ''
      Fast log colorizer written in C, intended to be a drop-in replacement
      for the Perl colorize tool.  Includes plugins for a variety of log
      formats (Apache, Postfix, Procmail, etc.).
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ malyn ];
    platforms = platforms.linux;
  };
}
