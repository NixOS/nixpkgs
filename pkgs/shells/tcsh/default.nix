{ stdenv, fetchurl, fetchpatch
, ncurses }:

stdenv.mkDerivation rec {
  pname = "tcsh";
  version = "6.21.00";

  src = fetchurl {
    urls = [
      "http://ftp.funet.fi/pub/mirrors/ftp.astron.com/pub/tcsh/${pname}-${version}.tar.gz"
      "ftp://ftp.astron.com/pub/tcsh/${pname}-${version}.tar.gz"
      "ftp://ftp.funet.fi/pub/unix/shells/tcsh/${pname}-${version}.tar.gz"
    ];
    sha256 = "0wp9cqkzdj5ahfyg9bn5z1wnyblqyv9vz4sc5aqmj7rp91a34f64";
  };

  buildInputs = [ ncurses ];

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl
    (fetchpatch {
      name = "sysmalloc.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/community/tcsh/001-sysmalloc.patch?id=184585c046cdd56512f1a76e426dd799b368f8cf";
      sha256 = "1qc6ydxhdfizsbkaxhpn3wib8sfphrw10xnnsxx2prvzg9g2zp67";
    });

  meta = with stdenv.lib;{
    description = "An enhanced version of the Berkeley UNIX C shell (csh)";
    longDescription = ''
      tcsh is an enhanced but completely compatible version of the
      Berkeley UNIX C shell, csh. It is a command language interpreter
      usable both as an interactive login shell and a shell script
      command processor.
      It includes:
      - command-line editor
      - programmable word completion
      - spelling correction
      - history mechanism
      - job control
    '';
    homepage = https://www.tcsh.org/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux ++ platforms.darwin;
  };

  passthru = {
    shellPath = "/bin/tcsh";
  };
}
