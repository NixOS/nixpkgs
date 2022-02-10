{ buildPythonPackage, lib, fetchFromGitHub, six, python-axolotl, pytest
, isPy3k, consonance, appdirs
}:

buildPythonPackage rec {
  pname = "yowsup";
  version = "3.3.0";

  # The Python 2.x support of this package is incompatible with `six==1.11`:
  # https://github.com/tgalal/yowsup/issues/2416#issuecomment-365113486
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "yowsup";
    rev = "v${version}";
    sha256 = "1pz0r1gif15lhzdsam8gg3jm6zsskiv2yiwlhaif5rl7lv3p0v7q";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test yowsup
  '';

  patches = [ ./dependency-fixes.patch ];

  propagatedBuildInputs = [ six python-axolotl consonance appdirs ];

  meta = with lib; {
    homepage = "https://github.com/tgalal/yowsup";
    description = "The python WhatsApp library";
    license = licenses.gpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
