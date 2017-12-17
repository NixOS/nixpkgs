{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "v0.9.10";
  name = "smenu-${version}";

  src = fetchFromGitHub {
    owner  = "p-gen";
    repo   = "smenu";
    rev    = version;
    sha256 = "1fh0s5zhx8ps760w0yxjv682lhahz1j63i0gdwvvr5vnvyx6c40d";
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
    platforms   = platforms.linux;
  };
}

