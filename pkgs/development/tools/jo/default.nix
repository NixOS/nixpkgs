{lib, stdenv, fetchFromGitHub, autoreconfHook, pandoc, pkg-config}:

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

  nativeBuildInputs = [ autoreconfHook pandoc pkg-config ];

  meta = with lib; {
    description = "A small utility to create JSON objects";
    homepage = "https://github.com/jpmens/jo";
    license = licenses.gpl2Plus;
    maintainers = [maintainers.markus1189];
    platforms = platforms.all;
  };
}
