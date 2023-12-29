{ lib
, python3
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "baboossh";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cybiere";
    repo = "baboossh";
    rev = "refs/tags/v${version}";
    hash = "sha256-dorIqnJuAS/y9W6gyt65QjwGwx4bJHKLmdqRPzY25yA=";
  };

  patches = fetchpatch {
    name = "py3compat-utils.patch";
    url = "https://github.com/cybiere/baboossh/commit/f7a75ebeda0c69ab5b119894b9e1488fc0a935a8.patch";
    hash = "sha256-gctuu/Qd3nmJIWv2mTyrGwjlQD1U+OhGK6Zh/Un06/E=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    cmd2
    tabulate
    paramiko
    python-libnmap
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "baboossh"
  ];

  meta = with lib; {
    description = "Tool to do SSH spreading";
    homepage = "https://github.com/cybiere/baboossh";
    changelog = "https://github.com/cybiere/baboossh/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
