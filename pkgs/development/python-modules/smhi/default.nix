{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "smhi";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "joysoftware";
    repo = "pypi_smhi";
    rev = version;
    sha256 = "0vf52bx9x2yz95z8w8538f0sj3hqqpnkip1lj87xjzh7hh6bjfqa";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # It connects to opendata-download-metfcst.smhi.se:443 during tests
  doCheck = false;

  pythonImportsCheck = [ "smhi" ];

  meta = with lib; {
    description = "Python library for accessing SMHI open forecast data";
    homepage = "https://github.com/joysoftware/pypi_smhi";
    changelog = "https://github.com/joysoftware/pypi_smhi/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
