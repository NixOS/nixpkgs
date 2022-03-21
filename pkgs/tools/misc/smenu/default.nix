{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "0.9.19";
  pname = "smenu";

  src = fetchFromGitHub {
    owner = "p-gen";
    repo = "smenu";
    rev = "v${version}";
    sha256 = "sha256-0ZA8Op1IMZMJ7g1waK2uOYOCDfqPfiqnnjopGtBW1w8=";
  };

  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "https://github.com/p-gen/smenu";
    description = "Terminal selection utility";
    longDescription = ''
      Terminal utility that allows you to use words coming from the standard
      input to create a nice selection window just below the cursor. Once done,
      your selection will be sent to standard output.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthiasbeyer SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
