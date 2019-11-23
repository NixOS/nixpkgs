{ stdenv, fetchPypi, python }:

python.pkgs.buildPythonPackage rec {
  pname   = "tld";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0figmf80y715zv6viqan2nyzpg9aia5dyl25nskirpm5lh1s99w9";
  };

  propagatedBuildInputs = with python.pkgs; [ six ];
  checkInputs = with python.pkgs; [ factory_boy faker pytestcov tox pytestCheckHook];

  # https://github.com/barseghyanartur/tld/issues/54
  disabledTests = [
    "test_1_update_tld_names"
    "test_1_update_tld_names_command"
    "test_2_update_tld_names_module"
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin"
  '';

  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [
    "tld"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/barseghyanartur/tld;
    description = "Extracts the top level domain (TLD) from the URL given";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ genesis ];
  };

}
