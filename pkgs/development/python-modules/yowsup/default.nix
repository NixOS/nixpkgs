{ buildPythonPackage, stdenv, fetchFromGitHub, six, python-axolotl, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "yowsup";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "yowsup";
    rev = "v${version}";
    sha256 = "16l8jmr32wwvl11m0a4r4id3dkfqj2n7dn6gky1077xwmj2da4fl";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test yowsup
  '';

  patches = [ ./argparse-dependency.patch ];

  propagatedBuildInputs = [ six python-axolotl ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/tgalal/yowsup";
    description = "The python WhatsApp library";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma27 ];
  };
}
