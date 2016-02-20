{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "pagemon-${version}";
  version = "0.01.08";

  src = fetchFromGitHub {
    sha256 = "079x8ah33nh4faqcy0jy24x30l40j5m00d57aawaayaq18smqs3f";
    rev = "V${version}";
    repo = "pagemon";
    owner = "ColinIanKing";
  };

  buildInputs = [ ncurses ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man/man8"
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Interactive memory/page monitor for Linux";
    longDescription = ''
      pagemon is an ncurses based interactive memory/page monitoring tool
      allowing one to browse the memory map of an active running process
      on Linux.
      pagemon reads the PTEs of a given process and display the soft/dirty
      activity in real time. The tool identifies the type of memory mapping
      a page belongs to, so one can easily scan through memory looking at
      pages of memory belonging data, code, heap, stack, anonymous mappings
      or even swapped-out pages.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
