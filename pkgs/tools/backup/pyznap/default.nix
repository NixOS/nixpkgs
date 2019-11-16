{ lib
, buildPythonApplication
, fetchPypi
, setuptools
}:

buildPythonApplication rec {
  pname = "pyznap";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00xpw6rmkq5cfjfw23mv0917wfzvb5zxj420p6yh0rnl3swh7gi8";
  };

  propagatedBuildInputs = [
    setuptools
  ];  

  # tests aren't included in the PyPI packages
  doCheck = false;

  meta = {
    homepage = "https://github.com/yboetz/pyznap";
    description = "ZFS snapshot tool written in python";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ rbrewer ];
  };
}
