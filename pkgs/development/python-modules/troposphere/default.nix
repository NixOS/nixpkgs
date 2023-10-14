{ lib
, awacs
, buildPythonPackage
, cfn-flip
, fetchFromGitHub
, pythonOlder
, typing-extensions
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "troposphere";
  version = "4.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ecRpp8XsP/iv4G8m85qcGJXHXH4CPdgBO8c0IZU56wU=";
  };

  propagatedBuildInputs = [
    cfn-flip
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    awacs
    unittestCheckHook
  ];

  passthru.optional-dependencies = {
    policy = [
      awacs
    ];
  };

  pythonImportsCheck = [
    "troposphere"
  ];

  meta = with lib; {
    description = "Library to create AWS CloudFormation descriptions";
    homepage = "https://github.com/cloudtools/troposphere";
    changelog = "https://github.com/cloudtools/troposphere/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
