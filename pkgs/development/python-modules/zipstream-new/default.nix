{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zipstream-new";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xhw24zhibmyypcdbmvql02jcf3npisb29lx71w1drcl3ccgwcdh";
  };

  # No tests in PyPI archive
  doCheck = false;

  pythonImportsCheck = [ "zipstream" ];

  meta = with lib; {
    description = "A zip archive generator";
    homepage = "https://github.com/arjan-s/python-zipstream";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
