{ lib
, buildPythonApplication
, fetchPypi
, setuptools
}:

buildPythonApplication rec {
  pname = "pyznap";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s8glb6kbwwha6zgzfrf195r1qkrv1a9wagyhhm3kryv7c88mqnp";
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
