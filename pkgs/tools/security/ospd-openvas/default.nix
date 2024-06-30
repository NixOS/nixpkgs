{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ospd-openvas";
  version = "22.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "ospd-openvas";
    rev = "refs/tags/v${version}";
    hash = "sha256-bFZTwNITDG5OpoWD7F1Ad6BQFpY4Q5CGUGbYy7rTuc0=";
  };

  pythonRelaxDeps = [
    "packaging"
    "python-gnupg"
  ];

  build-system = with python3.pkgs; [ poetry-core ];


  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    deprecated
    lxml
    packaging
    paho-mqtt
    psutil
    python-gnupg
    redis
    sentry-sdk
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "ospd_openvas" ];

  meta = with lib; {
    description = "OSP server implementation to allow GVM to remotely control an OpenVAS Scanner";
    homepage = "https://github.com/greenbone/ospd-openvas";
    changelog = "https://github.com/greenbone/ospd-openvas/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
