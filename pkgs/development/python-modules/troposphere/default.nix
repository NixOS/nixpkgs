{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python

  # python dependencies
, awacs
, cfn-flip
, typing-extensions
}:

buildPythonPackage rec {
  pname = "troposphere";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = pname;
    rev = version;
    hash = "sha256-4flnV4WxK21NNd9FXizkw6FoGffSL27Tq/Jc87vYJbc=";
  };

  propagatedBuildInputs = [
    cfn-flip
  ] ++ lib.lists.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    awacs
  ];

  passthru.optional-dependencies = {
    policy = [ awacs ];
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [ "troposphere" ];

  meta = with lib; {
    description = "Library to create AWS CloudFormation descriptions";
    maintainers = with maintainers; [ jlesquembre ];
    license = licenses.bsd2;
    homepage = "https://github.com/cloudtools/troposphere";
    changelog = "https://github.com/cloudtools/troposphere/blob/${version}/CHANGELOG.rst";
  };
}
