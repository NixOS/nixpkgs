{ buildPythonPackage, stdenv, fetchFromGitHub, six, python-axolotl, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "yowsup";
  version = "2.5.7";

  # The Python 2.x support of this package is incompatible with `six==1.11`:
  # https://github.com/tgalal/yowsup/issues/2416#issuecomment-365113486
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "yowsup";
    rev = "v${version}";
    sha256 = "1p0hdj5x38v2cxjnhdnqcnp5g7la57mbi365m0z83wa01x2n73w6";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test yowsup
  '';

  patches = [ ./argparse-dependency.patch ];

  propagatedBuildInputs = [ six python-axolotl ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tgalal/yowsup;
    description = "The python WhatsApp library";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma27 ];
  };
}
