{ stdenv, fetchgit, autoreconfHook, which }:

stdenv.mkDerivation rec {
  name = "torsocks-${version}";
  version = "2.2.0";

  src = fetchgit {
    url    = meta.repositories.git;
    rev    = "refs/tags/v${version}";
    sha256 = "1xwkmfaxhhnbmvp37agnby1n53hznwhvx0dg1hj35467qfx985zc";
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
