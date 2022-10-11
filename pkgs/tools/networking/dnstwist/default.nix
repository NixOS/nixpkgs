{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnstwist";
  version = "20221011";

  src = fetchFromGitHub {
    owner = "elceef";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-fUbcSopMbYk6vfu6W+HbrWx4BiOVcTWkuvpzVU/0MkI=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
    GeoIP
    ppdeep
    requests
    tld
    whois
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dnstwist"
  ];

  meta = with lib; {
    description = "Domain name permutation engine for detecting homograph phishing attacks";
    homepage = "https://github.com/elceef/dnstwist";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
