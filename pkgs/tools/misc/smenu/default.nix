{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "0.9.15";
  name = "smenu-${version}";

  src = fetchFromGitHub {
    owner  = "p-gen";
    repo   = "smenu";
    rev    = "v${version}";
    sha256 = "0s9qhg6dln33x8r2g8igvgkyrv8g1z26wf8gcnqp3kbp6fw12izi";
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
    maintainers = [ maintainers.matthiasbeyer ];
    platforms   = platforms.unix;
  };
}

