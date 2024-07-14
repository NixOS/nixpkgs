{ lib
, buildPythonApplication
, fetchPypi
, setuptools
}:

buildPythonApplication rec {
  pname = "pyznap";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iL8dbeLBHxSsvfoBth65XJT5XYKd3r2u43hrZMy5OuM=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  # tests aren't included in the PyPI packages
  doCheck = false;

  meta = {
    homepage = "https://github.com/yboetz/pyznap";
    description = "ZFS snapshot tool written in python";
    mainProgram = "pyznap";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ rbrewer ];
  };
}
