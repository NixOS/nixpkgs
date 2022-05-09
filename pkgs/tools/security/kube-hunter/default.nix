{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kube-hunter";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-W7jW0V91o164EIAzZ7ODWeqTmUaUFDIqlE37x/AycqY=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    netaddr
    netifaces
    scapy
    requests
    prettytable
    urllib3
    ruamel-yaml
    future
    packaging
    pluggy
    kubernetes
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "dataclasses" "" \
      --replace "kubernetes==12.0.1" "kubernetes" \
      --replace "--cov=kube_hunter" ""
  '';

  pythonImportsCheck = [
    "kube_hunter"
  ];

  meta = with lib; {
    description = "Tool to search issues in Kubernetes clusters";
    homepage = "https://github.com/aquasecurity/kube-hunter";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
