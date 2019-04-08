{ lib
, buildPythonApplication
, fetchPypi
, paramiko
, configparser
}:

buildPythonApplication rec {
  pname = "pyznap";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ac0da5d7f6461d1d6f128362786e297144b415f9e3a2f1835642ab3dda82d55";
  };

  propagatedBuildInputs = [ configparser paramiko ];

  # tests aren't included in the PyPI packages
  doCheck = false;

  meta = {
    homepage = "https://github.com/yboetz/pyznap";
    description = "ZFS snapshot tool written in python";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ rbrewer ];
  };
}
