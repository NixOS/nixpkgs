{ lib
, buildPythonApplication
, fetchPypi
}:

buildPythonApplication rec {
  pname = "pyznap";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pnngr4zdxkf6b570ikzvkrm3a8fr47w6crjaw7ln094qkniywvj";
  };

  # tests aren't included in the PyPI packages
  doCheck = false;

  meta = {
    homepage = "https://github.com/yboetz/pyznap";
    description = "ZFS snapshot tool written in python";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ rbrewer ];
  };
}
