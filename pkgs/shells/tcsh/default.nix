{ lib
, stdenv
, fetchurl
, fetchpatch
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "tcsh";
  version = "6.24.00";

  src = fetchurl {
    url = "mirror://tcsh/${pname}-${version}.tar.gz";
    hash = "sha256-YL4sUEvY8fpuQksZVkldfnztUqKslNtf0n9La/yPdPA=";
  };

  buildInputs = [
    ncurses
  ];

  patches = lib.optional stdenv.hostPlatform.isMusl
    # Use system malloc
    (fetchpatch {
      name = "sysmalloc.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/tcsh/001-sysmalloc.patch?id=184585c046cdd56512f1a76e426dd799b368f8cf";
      sha256 = "1qc6ydxhdfizsbkaxhpn3wib8sfphrw10xnnsxx2prvzg9g2zp67";
    });

  meta = with lib; {
    homepage = "https://www.tcsh.org/";
    description = "An enhanced version of the Berkeley UNIX C shell (csh)";
    longDescription = ''
      tcsh is an enhanced but completely compatible version of the Berkeley UNIX
      C shell, csh. It is a command language interpreter usable both as an
      interactive login shell and a shell script command processor.

      It includes:
      - command-line editor
      - programmable word completion
      - spelling correction
      - history mechanism
      - job control
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };

  passthru.shellPath = "/bin/tcsh";
}
