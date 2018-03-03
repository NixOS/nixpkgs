{ lib
, pythonPackages
, fetchpatch
}:

with pythonPackages;

buildPythonApplication rec {
  pname = "diceware";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0855n4dh16ws1dhw1ixxwk3wx7qr45xff7pn32pjg58p4z4cx168";
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
