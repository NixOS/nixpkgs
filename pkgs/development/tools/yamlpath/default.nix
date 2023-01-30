{ lib
, fetchFromGitHub
, hiera-eyaml
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "yamlpath";
  version = "3.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wwkimball";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-07WP3VoWtcUwqkJOC9FcYxV0832DH6KPcGIDAn1QEYc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    python-dateutil
    ruamel-yaml
  ];

  nativeCheckInputs = with python3.pkgs; [
    hiera-eyaml
    mock
    pytest-console-scripts
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  pythonImportsCheck = [
    "yamlpath"
  ];

  meta = with lib; {
    description = "Command-line processors for YAML/JSON/Compatible data";
    homepage = "https://github.com/wwkimball/yamlpath";
    longDescription = ''
      Command-line get/set/merge/validate/scan/convert/diff processors for YAML/JSON/Compatible data
      using powerful, intuitive, command-line friendly syntax
     '';
    license = licenses.isc;
    maintainers = with maintainers; [ Flakebi ];
  };
}
