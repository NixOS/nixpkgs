{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mkosi";
  version = "13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    rev = "v${version}";
    hash = "sha256-4eBxxCPpMcbnTtGpYw0FuxdNZ7sxSbaaavoJZ6Kboa0=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pexpect
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Build legacy-free OS images";
    homepage = "https://github.com/systemd/mkosi";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ onny ];
  };
}
