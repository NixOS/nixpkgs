{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wafw00f";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-wJZ1/aRMFpE6Q5YAtGxXwxe2G9H/de+l3l0C5rwEWA8=";
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
    mainProgram = "wafw00f";
    homepage = "https://github.com/EnableSecurity/wafw00f";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
