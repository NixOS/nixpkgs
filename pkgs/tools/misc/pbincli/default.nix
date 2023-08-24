{ lib
, fetchPypi
, python3
, runCommand
, pbincli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "PBinCLI";
  version = "0.3.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z9l4/4GV9/WGoTCVvCy7xD02n9dIjZUbMr/2t8xwa+Q=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pycryptodome
    sjcl
    base58
    requests
  ];

  pythonImportsCheck = [ "pbincli" ];

  passthru.tests = {
    binaryWorks = runCommand "${pname}-binary-test" {} ''
      export PATH=${pbincli}/bin:$PATH
      pbincli send --help | grep "Send data to PrivateBin instance"
      pbincli get --help | grep "Get data from PrivateBin instance"
      pbincli delete --help | grep "Delete paste from PrivateBin instance"

      touch $out
    '';
  };

  meta = with lib; {
    description = "Command line client for PrivateBin";
    homepage = "https://github.com/r4sas/PBinCLI/";
    changelog = "https://github.com/r4sas/PBinCLI/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ e1mo ];
  };
}
