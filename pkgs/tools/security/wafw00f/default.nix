{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wafw00f";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "0526kz6ypww9nxc2vddkhpn1gqvn25mzj3wmi91wwxwxjjb6w4qj";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
    pluginbase
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "wafw00f"
  ];

  meta = with lib; {
    description = "Tool to identify and fingerprint Web Application Firewalls (WAF)";
    homepage = "https://github.com/EnableSecurity/wafw00f";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
