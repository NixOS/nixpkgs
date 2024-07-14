{ lib, python3Packages, fetchPypi }:

with python3Packages;

buildPythonApplication rec {
  pname = "vim-vint";
  version = "0.3.21";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XcWbLlwqdGyI9fUfP6/qPWOcaw/bsRa7dK8nvxyCDZc=";
  };

  # For python 3.5 > version > 2.7 , a nested dependency (pythonPackages.hypothesis) fails.
  disabled = ! pythonAtLeast "3.5";

  nativeCheckInputs = [ pytest pytest-cov ];
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
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
