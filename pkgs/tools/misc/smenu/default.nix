{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "v0.9.11";
  name = "smenu-${version}";

  src = fetchFromGitHub {
    owner  = "p-gen";
    repo   = "smenu";
    rev    = version;
    sha256 = "1va5gsxniin02casgdrqxvpzccm0vwjiql60qrsvncrq6nm6bz0d";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage        = https://github.com/p-gen/smenu;
    description     = "Terminal selection utility";
    longDescription = ''
      Terminal utility that allows you to use words coming from the standard
      input to create a nice selection window just below the cursor. Once done,
      your selection will be sent to standard output.
    '';
    license     = licenses.gpl2;
    maintainers = [ ];
    platforms   = platforms.linux;
  };
}

