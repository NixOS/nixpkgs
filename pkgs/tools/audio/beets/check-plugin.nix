{ stdenv, fetchFromGitHub, beets, pythonPackages, flac, liboggz, mp3val }:

pythonPackages.buildPythonApplication rec {
  name = "beets-check";
  version = "0.12.0";

  src = fetchFromGitHub {
    repo = "beets-check";
    owner = "geigerzaehler";
    rev = "v${version}";
    sha256 = "0b2ijjf0gycs6b40sm33ida3sjygjiv4spb5mba52vysc7iwmnjn";
  };

  nativeBuildInputs = [ beets ];
  checkInputs = [ pythonPackages.nose flac liboggz mp3val ];
  propagatedBuildInputs = [ flac liboggz mp3val ];

  # patch out broken tests
  patches = [ ./beet-check-tests.patch ];

  # patch out futures dependency, it is only needed for Python2 which we don't
  # support.
  prePatch = ''
    sed -i "/futures/d" setup.py
  '';

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    description = "Beets plugin to Verify and store checksums in your library";
    homepage = https://github.com/geigerzaehler/beets-check;
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
