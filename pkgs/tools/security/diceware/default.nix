{ lib
, pythonPackages
, fetchpatch
}:

with pythonPackages;

buildPythonApplication rec {
  pname = "diceware";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p09q6945qvdmvckjl8rfqx0g8nf6igc3c6rab6v74k9bsmbf15p";
  };

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [ pytest ];

  # NOTE: remove once 0.9.4 is released
  patches = [
    (fetchpatch {
      url = "${meta.homepage}/commit/86379bf49ade2b486071d6d330515f01ecb06ab4.patch";
      sha256 = "0nxvxiqvxfsa9y6zwy9k7shsd0fk92psdzi4klqwd4wy3lbmw8di";
    })
    (fetchpatch {
      url = "${meta.homepage}/commit/a7d844df76cd4b95a717f21ef5aa6167477b6733.patch";
      sha256 = "0ab4fc2pbl2hcxqw5rr6awbhlnmdna6igqjijywwr1byzb7ga4iq";
    })
  ];

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
