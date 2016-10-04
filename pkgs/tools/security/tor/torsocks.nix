{ stdenv, fetchgit, autoreconfHook, which }:

stdenv.mkDerivation rec {
  name = "torsocks-${version}";
  version = "2.1.0";

  src = fetchgit {
    url    = meta.repositories.git;
    rev    = "refs/tags/v${version}";
    sha256 = "1l890pg0h2hqpkabsnwc6pq2qi8mfv58qzaaicc9y62rq5nmrrws";
  };

  buildInputs = [ autoreconfHook ];
  preConfigure = ''
      export configureFlags="$configureFlags --libdir=$out/lib"
  '';

  patchPhase = ''
    substituteInPlace src/bin/torsocks.in \
      --replace which ${which}/bin/which
  '';

  meta = {
    description      = "Wrapper to safely torify applications";
    homepage         = http://code.google.com/p/torsocks/;
    repositories.git = https://git.torproject.org/torsocks.git;
    license          = stdenv.lib.licenses.gpl2;
    platforms        = stdenv.lib.platforms.unix;
    maintainers      = with stdenv.lib.maintainers; [ phreedom thoughtpolice ];
  };
}
