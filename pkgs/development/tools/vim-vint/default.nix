{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "vim-vint";
  version = "0.3.21";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "15qdh8fby9xgfjxidcfv1xmrqqrxxapky7zmyn46qx1abhp9piax";
  };

  # For python 3.5 > version > 2.7 , a nested dependency (pythonPackages.hypothesis) fails.
  disabled = ! pythonAtLeast "3.5";

  checkInputs = [ pytest pytest-cov ];
  propagatedBuildInputs = [ ansicolor chardet pyyaml setuptools ];

  # Unpin test dependency versions. This is fixed in master but not yet released.
  preCheck = ''
    sed -i 's/==.*//g' test-requirements.txt
    sed -i 's/mock == 1.0.1/mock/g' setup.py
  '';

  meta = with lib; {
    description = "Fast and Highly Extensible Vim script Language Lint implemented by Python";
    homepage = "https://github.com/Kuniwak/vint";
    license = licenses.mit;
    mainProgram = "vint";
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.all;
  };
}
