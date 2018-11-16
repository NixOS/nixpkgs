{ lib
, pythonPackages
}:

with pythonPackages;

buildPythonApplication rec {
  pname = "diceware";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22a998361fd2afbc7890062e228235b3501084de1e6a5bb61f16d2637977f50d";
  };

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [ coverage pytest ];

  # see https://github.com/ulif/diceware/commit/a7d844df76cd4b95a717f21ef5aa6167477b6733
  checkPhase = ''
    py.test -m 'not packaging'
  '';

  meta = with lib; {
    description = "Generates passphrases by concatenating words randomly picked from wordlists";
    homepage = https://github.com/ulif/diceware;
    license = licenses.gpl3;
    maintainers = with maintainers; [ asymmetric ];
  };
}
