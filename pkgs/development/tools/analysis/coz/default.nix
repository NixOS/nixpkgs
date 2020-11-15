{ stdenv
, fetchFromGitHub
, libelfin
, ncurses
, python3
, python3Packages
, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "coz";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "plasma-umass";
    repo = "coz";
    rev = version;
    sha256 = "0val36yw987b1558iiyk3nqg0yy5k9y5wh49v91zj3cs58mmfyhc";
  };

  postPatch = ''
    sed -i -e '/pid_t gettid/,+2d' libcoz/ccutil/thread.h
  '';

  postConfigure = ''
    # This is currently hard-coded. Will be fixed in the next release.
    sed -e "s|/usr/lib/|$out/lib/|" -i ./coz
  '';

  nativeBuildInputs = [
    ncurses
    makeWrapper
    python3Packages.wrapPython
  ];

  buildInputs = [
    libelfin
    (python3.withPackages (p: [ p.docutils ]))
  ];

  installPhase = ''
    mkdir -p $out/share/man/man1
    make install prefix=$out

    # fix executable includes
    chmod -x $out/include/coz.h

    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://github.com/plasma-umass/coz";
    description = "Coz: Causal Profiling";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ zimbatm ];
  };
}
