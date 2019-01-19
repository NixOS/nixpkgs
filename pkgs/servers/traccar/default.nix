{ stdenv, fetchFromGitHub, maven  }:

stdenv.mkDerivation rec {

  pname = "traccar";
  version = "4.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "traccar";
    rev = "v${version}";
    sha256 = "1xqnqz53h5yw5l1qc2mi35pnwihjfwpfccy86wl6jphl968w1czn";
    fetchSubmodules = true;
  };

  # How to build with Maven????
  #
  # Build instructions:
  # https://www.traccar.org/build/

  buildInputs = [ maven ];

  buildPhase = ''
    mvn package
  '';

  meta = with stdenv.lib; {
    description = "Modern GPS tracking platform";
    homepage = https://www.traccar.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ jluttine ];
    platforms = platforms.linux;
  };

}
