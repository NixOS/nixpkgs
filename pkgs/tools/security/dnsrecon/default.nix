{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsrecon";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = "dnsrecon";
    rev = "refs/tags/${version}";
    hash = "sha256-XboRxq3ZDIDtuECVSnncQ2Pa8YAvva4KUNm0O5ED6rc=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    dnspython
    netaddr
    lxml
    setuptools
  ];

  # Tests require access to /etc/resolv.conf
  doCheck = false;

  pythonImportsCheck = [ "dnsrecon" ];

  meta = with lib; {
    description = "DNS Enumeration script";
    homepage = "https://github.com/darkoperator/dnsrecon";
    changelog = "https://github.com/darkoperator/dnsrecon/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      c0bw3b
      fab
    ];
    mainProgram = "dnsrecon";
  };
}
