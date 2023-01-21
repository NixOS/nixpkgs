{ lib, fetchpatch, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "csvkit";
  version = "1.0.5";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1ffmbzk4rxnl1yhqfl58v7kvl5m9cbvjm8v7xp4mvr00sgs91lvv";
  };

  patches = [
    # Fixes a failing dbf related test. Won't be needed on 1.0.6 or later.
    (fetchpatch {
      url = "https://github.com/wireservice/csvkit/commit/5f22e664121b13d9ff005a9206873a8f97431dca.patch";
      sha256 = "1kg00z65x7l6dnm5nfsr5krs8m7mv23hhb1inkaqf5m5fpkpnvv7";
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    agate
    agate-excel
    agate-dbf
    agate-sql
    six
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "csvkit" ];

  meta = with lib; {
    description = "A suite of command-line tools for converting to and working with CSV";
    maintainers = with maintainers; [ vrthra ];
    license = licenses.mit;
    homepage = "https://github.com/wireservice/csvkit";
  };
}
