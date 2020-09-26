{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "0.9.16";
  pname = "smenu";

  src = fetchFromGitHub {
    owner  = "p-gen";
    repo   = "smenu";
    rev    = "v${version}";
    sha256 = "1vlsrc071fznqnz67jbhrc4pcfwzc737lwd9jxpnidn0i08py5p2";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage        = "https://github.com/p-gen/smenu";
    description     = "Terminal selection utility";
    longDescription = ''
      Terminal utility that allows you to use words coming from the standard
      input to create a nice selection window just below the cursor. Once done,
      your selection will be sent to standard output.
    '';
    license     = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms   = platforms.unix;
  };
}

