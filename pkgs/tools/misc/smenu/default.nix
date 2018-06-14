{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "0.9.13";
  name = "smenu-${version}";

  src = fetchFromGitHub {
    owner  = "p-gen";
    repo   = "smenu";
    rev    = "v${version}";
    sha256 = "0ixfl1dxkvmzb3xy6zs1x94hlf8y7zmd14gmb50rp7gb7ff1ivm5";
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

