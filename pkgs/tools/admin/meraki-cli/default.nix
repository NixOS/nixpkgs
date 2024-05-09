{ lib
, argcomplete
, jinja2
, meraki
, rich
, fetchPypi
, buildPythonApplication
, pytestCheckHook
, requests-mock
}:

buildPythonApplication rec {
  pname = "meraki-cli";
  version = "1.5.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "meraki_cli";
    inherit version;
    hash = "sha256-YOyeovqRqt6ZMXgLnIxRvPkcW259K8NIBGdb3PwjkMg=";
  };

  disabledTests = [
    # requires files not in PyPI tarball
    "TestDocVersions"
    "TestHelps"
    # requires running "pip install"
    "TestUpgrade"
  ];

  propagatedBuildInputs = [
    argcomplete
    jinja2
    meraki
    rich
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  nativeCheckInputs = [
    requests-mock
  ];

  pythonImportsCheck = [
    "meraki_cli"
  ];

  meta = with lib; {
    homepage = "https://github.com/PackeTsar/meraki-cli";
    description = "A simple CLI tool to automate and control your Cisco Meraki Dashboard";
    license = licenses.mit;
    maintainers = with maintainers; [ dylanmtaylor ];
    platforms = platforms.unix;
    mainProgram = "meraki";
  };
}
