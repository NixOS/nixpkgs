{ stdenv, fetchgit, autoreconfHook, which }:

stdenv.mkDerivation rec {
  name = "torsocks-${version}";
  version = "2.0.0";

  src = fetchgit {
    url    = meta.repositories.git;
    rev    = "refs/tags/v${version}";
    sha256 = "e3868ae8baadce1854cc9e604a5fcfa0433a15e4eb1223cc9da5b3c586db0048";
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
