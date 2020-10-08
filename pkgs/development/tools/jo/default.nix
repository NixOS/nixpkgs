{stdenv, fetchFromGitHub, autoreconfHook, pandoc, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "jo";
  version = "1.4";

  src = fetchFromGitHub {
    owner  = "jpmens";
    repo = "jo";
    rev = version;
    sha256 ="1jnv3g38vaa66m83hqibyki31ii81xfpvjw6wgdv18ci3iwvsz3v";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook pandoc pkgconfig ];

  meta = with stdenv.lib; {
    description = "A small utility to create JSON objects";
    homepage = "https://github.com/jpmens/jo";
    license = licenses.gpl2Plus;
    maintainers = [maintainers.markus1189];
    platforms = platforms.all;
  };
}
