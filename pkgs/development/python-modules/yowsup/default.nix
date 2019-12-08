{ buildPythonPackage, stdenv, fetchFromGitHub, six, python-axolotl, pytest
, isPy3k, consonance, appdirs
}:

buildPythonPackage rec {
  pname = "yowsup";
  version = "3.2.3";

  # The Python 2.x support of this package is incompatible with `six==1.11`:
  # https://github.com/tgalal/yowsup/issues/2416#issuecomment-365113486
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "yowsup";
    rev = "v${version}";
    sha256 = "0wb8yl685nr1i3vx89hwan5m6a482x8g48f5ksvdlph538p720pm";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test yowsup
  '';

  patches = [ ./dependency-fixes.patch ];

  propagatedBuildInputs = [ six python-axolotl consonance appdirs ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/tgalal/yowsup";
    description = "The python WhatsApp library";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma27 ];
  };
}
