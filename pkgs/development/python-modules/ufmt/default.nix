{ lib
, black
, buildPythonPackage
, click
, fetchFromGitHub
, flit-core
, libcst
, moreorless
, pythonOlder
, tomlkit
, trailrunner
, typing-extensions
, unittestCheckHook
, usort
}:

buildPythonPackage rec {
  pname = "ufmt";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "ufmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-eQIbSC0Oxi6JD7/3o2y9f+KhT8GIiFiYiV4A3QBoWl0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    black
    click
    libcst
    moreorless
    tomlkit
    trailrunner
    typing-extensions
    usort
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "ufmt"
  ];

  meta = with lib; {
    description = "Safe, atomic formatting with black and usort";
    homepage = "https://github.com/omnilib/ufmt";
    changelog = "https://github.com/omnilib/ufmt/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
